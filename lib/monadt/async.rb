require 'monadt/adt'

module Monadt
  class Async
    class << self

      def bind(m, &blk)
        blk.call(m.resume)
      end

      def return(a)
        Fiber.new { a }
      end
    end

  end
end

