require 'monadt/adt'

module Monadt
  class Async
    class << self

      def bind(m, &blk)
        a = m.resume
        m2 = blk.call(a)
        if m2.alive?
          m2
        else
          self.return a
        end
      end

      def return(a)
        Fiber.new { a }
      end
    end

  end
end

