require 'pry'

AdtPattern = Struct.new :klass, :lambda

def data(*fields)
  base = if fields.size > 0
           Struct.new(*fields)
         else
           Object
         end
  Class.new(base)
end

def decorate_adt(klass)
  klass.constants.each do |v|
    name = v.to_s.downcase
    const = klass.const_get v
    klass.constants.each do |is_v|
      is_name = is_v.to_s.downcase
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
    params =
      if m.lambda.arity > 0
        o.values.take(m.lambda.arity)
      else
        []
      end
    m.lambda.call(*params)
  end

  def with(klass, prc=nil, &blk)
    AdtPattern.new klass, prc || blk
  end
end


