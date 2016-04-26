require 'fiber'

module Monadt
  module Fibr
    class MonadObj
      def initialize(klass)
        @klass = klass
      end

      def return(val)
        @klass.return val
      end

      def bind(val)
        Fiber.yield val
      end
    end
  end

  class DoMFiber
    class << self
      def do_m(klass, &blk)
        f = Fiber.new do |y|
          m_obj = Fibr::MonadObj.new klass
          blk.call(m_obj)
        end
        do_m_recur(klass, f, nil)
      end

      def do_m_recur(klass, f, ma, *args)
        if f.alive?
          ma = f.resume(*args)
          klass.bind(ma) do |a|
            do_m_recur(klass, f, ma, a)
          end
        else
          ma
        end
      end
    end
  end
end
