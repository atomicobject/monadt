require 'fiber'

module Monadt
  module Internal
    class MonadObjFiber
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

    class MonadObjEnum
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

  class Monad
    class << self
      def do_m(klass, &blk)
        do_m_fiber(klass, &blk)
      end

      def do_m_fiber(klass, &blk)
        f = Fiber.new do |y|
          m_obj = Internal::MonadObjFiber.new klass
          blk.call(m_obj)
        end
        do_m_recur_fiber(klass, f, nil)
      end

      def do_m_recur_fiber(klass, f, ma, *args)
        if f.alive?
          ma = f.resume(*args)
          klass.bind(ma) do |a|
            do_m_recur_fiber(klass, f, ma, a)
          end
        else
          ma
        end
      end

      def do_m_enum(klass, &blk)
        e = Enumerator.new do |y|
          m_obj = Internal::MonadObjEnum.new klass, y
          blk.call(m_obj)
        end
        do_m_recur_enum(klass, e)
      end

      def do_m_recur_enum(klass, e)
        begin
          ma = e.next
        rescue StopIteration => ex
          return ex.result
        end
        klass.bind(ma) do |a|
          e.feed a
          do_m_recur_enum(klass, e)
        end
      end
    end
  end
end

