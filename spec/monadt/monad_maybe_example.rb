require 'monadt/maybe'
require 'monadt/monad'

module Monadt
  class MaybeExample
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
        Monad.doM(Maybe) do |m|
          x = m.bind may1 v
          y = m.bind may2 x
          m.return (x + y)
        end
      end

      def maybe_func_stop_early(v)
        Monad.doM(Maybe) do |m|
          x = m.bind may1 v
          y = m.bind may2 x
          raise 'uh oh'
          m.return x + y
        end
      end
    end
  end
end
