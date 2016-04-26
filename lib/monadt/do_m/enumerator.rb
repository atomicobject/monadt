require 'fiber'

module Monadt
  module Enum
    class MonadObj
      def initialize(klass, yielder)
        @klass = klass
        @yielder = yielder
      end

      def return(val)
        @klass.return val
      end

      def bind(val)
        @yielder.yield val
      end
    end
  end

  class DoMEnumerator
    class << self
      def do_m(klass, &blk)
        e = Enumerator.new do |y|
          m_obj = Enum::MonadObj.new klass, y
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
