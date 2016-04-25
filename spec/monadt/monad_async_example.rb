require 'monadt'

module Monadt
  class AsyncExample
    class << self
      def async1(x)
        Fiber.new {
          x + 1
        }
      end

      def async2(y, z)
        if (y > 0)
          Fiber.new { z ** y }
        else
          Fiber.new { z - y }
        end
      end

      def async_func(v)
        Monad.async do |m|
          x = m.bind (async1 v)
          y = m.bind (async2 x, v)
          ret = m.return (x + y)
          ret
        end
      end
    end
  end
end
