require 'monadt'

module Monadt
  class MaybeExample
    class << self
      include Maybe

      def may1(x)
        Just.new x
      end

      def may2(z)
        if z > 0
          Just.new (z * 2)
        else
          Nothing.new
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
