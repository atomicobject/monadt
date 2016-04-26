require 'monadt/do_m'

module Monadt
  class ListExample
    class << self

      def list1(x)
        #Choice.failure "no"
        if x > 5
          [x - 5, x]
        else
          [x, x + 2]
        end
      end

      def list2(z)
        if z % 2 == 0
          [z, z / 2]
        else
          [z, z * 2]
        end
      end

      def list_func(v)
        Monad.do_m(List) do |m|
          x = m.bind (list1 v)
          y = m.bind (list2 x)
          List.return (x + y)
        end
      end
    end
  end
end
