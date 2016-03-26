AdtPattern = Struct.new :klass, :lambda

def data(*fields)
  base = if fields.size > 0
           Struct.new(*fields)
         else
           Object
         end
  Class.new(base)
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


