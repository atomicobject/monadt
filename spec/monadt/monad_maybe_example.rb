require 'monadt'

module Monadt
  class MaybeExample
    class << self

      def may1(x)
        Maybe.just x
      end

      def may2(z)
        if z > 0
          Maybe.just (z * 2)
        else
          Maybe.nothing
        end
      end

      def maybe_func(v)
        Monad.maybe do |m|
          x = m.bind may1 v
          y = m.bind may2 x
          m.return (x + y)
        end
      end

      def maybe_func_stop_early(v)
        Monad.maybe do |m|
          x = m.bind may1 v
          y = m.bind may2 x
          raise 'uh oh'
          m.return x + y
        end
      end
    end
  end

  class PresentExample
    class << self
      def may1(x)
        x
      end

      def may2(z)
        if z > 0
          z * 2
        else
          nil
        end
      end

      def maybe_func(v)
        Monad.present do |m|
          x = m.bind may1 v
          y = m.bind may2 x
          m.return (x + y)
        end
      end

      def maybe_func_stop_early(v)
        Monad.present do |m|
          x = m.bind may1 v
          y = m.bind may2 x
          raise 'uh oh'
          m.return x + y
        end
      end
    end
  end
end
