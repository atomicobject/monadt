module Monadt
  module Internal
    class MonadObj
      def initialize(klass, yielder)
        @yielder = yielder
        @klass = klass
      end

      def return(val)
        @klass.return val
      end

      def bind(val)
        @yielder.yield val
      end
    end
  end

  class Monad
    class << self
      def do_m(klass, &blk)
        e = Enumerator.new do |y|
          m_obj = Internal::MonadObj.new klass, y
          blk.call(m_obj)
        end
        do_m_recur(klass, e)
      end

      def do_m_recur(klass, e)
        begin
          ma = e.next
        rescue StopIteration => ex
          return ex.result
        end
        klass.bind(ma) do |a|
          e.feed a
          do_m_recur(klass, e)
        end
      end
    end
  end
end

