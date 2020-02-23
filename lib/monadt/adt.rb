require 'active_support/inflector'

AdtPattern = Struct.new :klass, :lambda

module KeyStruct
  def self.reader(*keys)
    fetch_key_struct(:reader, keys)
  end

  def self.accessor(*keys)
    fetch_key_struct(:accessor, keys)
  end

  instance_eval do
    alias :[] :accessor
  end

  private

  # for anonymous superclasses, such as
  #
  #    class Foo < KeyStruct[:a, :b]
  #    end
  #
  #  we want to be sure that if the code gets re-executed (e.g. the file
  #  gets loaded twice) the superclass will be the same object otherwise
  #  ruby will raise a TypeError: superclass mismatch.  So keep a cache of
  #  anonymous KeyStructs
  #
  #  But don't reuse the class if it has a name, i.e. if it was assigned to
  #  a constant.  If somebody does
  #
  #     Foo = KeyStruct[:a, :b]
  #     Bar = KeyStruct[:a, :b]
  #
  #  they should get different class definitions, in particular because the
  #  classname is used in #to_s and #inspect
  #
  def self.fetch_key_struct(access, keys)
    @cache ||= {}
    signature = [access, keys]
    @cache.delete(signature) if @cache[signature] and @cache[signature].name
    @cache[signature] ||= define_key_struct(access, keys)
  end

  def self.define_key_struct(access, keys)
    keys = keys.dup
    defaults = (Hash === keys.last) ? keys.pop.dup : {}
    keys += defaults.keys

    Class.new.tap do |klass|
      klass.class_eval do
        include Comparable

        send "attr_#{access}", *keys

        define_singleton_method(:keys) { keys }
        define_singleton_method(:defaults) { defaults }
        define_singleton_method(:access) { access }
        define_singleton_method(:display_name) { self.name || "KeyStruct.#{access}" }

        define_method(:initialize) do | args={} |
          args = defaults.merge(args)
          errors = []
          keys.each do |key|
            value = args.delete(key)
            instance_variable_set("@#{key}".to_sym, value)
            errors << "#{key.to_s}:" unless value
          end
          raise ArgumentError, "Invalid argument(s): #{errors.join(", ")} can't be nil" unless errors.size.zero?
          raise ArgumentError, "Invalid argument(s): #{args.keys.map(&:inspect).join(' ')} -- KeyStruct accepts #{keys.map(&:inspect).join(' ')}" if args.any?
        end

        define_method(:to_s) do
          "[#{self.class.display_name} #{keys.map{|key| "#{key}:#{self.send(key)}"}.join(' ')}]"
        end

        define_method(:inspect) do
          "<#{self.class.display_name}:0x#{self.object_id.to_s(16)} #{keys.map{|key| "#{key}:#{self.send(key).inspect}"}.join(' ')}>"
        end

        define_method(:to_hash) do
          Hash[*keys.map{ |key| [key, self.send(key)]}.flatten(1)]
        end

        define_method(:values) do
          to_hash.values
        end

        define_method(:==) do |other|
          self.class.keys.all?{|key| other.respond_to?(key) and self.send(key) == other.send(key)}
        end

        define_method(:<=>) do |other|
          keys.each do |key|
            cmp = (self.send(key) <=> other.send(key))
            return cmp unless cmp == 0
          end
          0
        end
      end
    end
  end
end

AdtPattern = KeyStruct[:klass, :lambda]

def data(*fields, key_struct: true)
  base = if fields.size > 0
           if key_struct
             KeyStruct[*fields]
           else
             Struct.new(*fields)
           end
         else
           Object
         end
  Class.new(base)
end

def decorate_adt(klass)
  klass.constants.each do |v|
    name = v.to_s.underscore
    const = klass.const_get v
    klass.constants.each do |is_v|
      is_name = is_v.to_s.underscore
      ret = is_v == v
      const.class_eval do
        define_method "is_#{is_name}?" do ret end
      end
    end
    const.class_eval do
      define_method "to_s" do
        if respond_to? :values
          "#{v.to_s}(#{values.join(", ")})"
        else
          v.to_s
        end
      end
    end
    klass.class_eval do
      define_singleton_method name do |*values| const.new(*values) end
    end
  end
end

Default = data

module Adt
  def match(o, *cases)
    m = cases.find do |tpl|
      tpl.klass == o.class || tpl.klass == Default
    end
    if o.respond_to?(:to_hash)
      if m.lambda.arity == 1
        params = o.to_hash.slice(*m.lambda.parameters.map { |p| p.last})
        m.lambda.call(**params)
      else
        m.lambda.call
      end
    else
      params =
      if m.lambda.arity > 0
        o.values.take(m.lambda.arity)
      else
        []
      end
      m.lambda.call(*params)
    end
  end

  def with(klass, prc=nil, &blk)
    AdtPattern.new klass: klass, lambda: prc || blk
  end
end


