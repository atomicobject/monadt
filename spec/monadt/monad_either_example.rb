require 'monadt'

module Monadt
  class EitherExample
    class << self

      def choose1(x)
        if x > 5
          Either.right (x - 5)
        else
          Either.left "less than 5"
        end
      end

      def choose2(z)
        if z % 2 == 0
          Either.right (z * 2)
        else
          Either.left "i need even numbers"
        end
      end

      def either_func(v)
        Monad.either do |m|
          x = m.bind (choose1 v)
          y = m.bind (choose2 x)
          m.return (x + y)
        end
      end

      def either_func_stop_early(v)
        Monad.either do |m|
          x = m.bind (choose1 v)
          raise 'uh oh'
          y = m.bind (choose2 x)
          m.return (x + y)
        end
      end
    end
  end
end
