require_relative 'do_m/fiber'
require_relative 'do_m/enumerator'

module Monadt
  class Monad

    class << self
      def engine
        if ENV['DO_M_ENGINE'].nil?
          DoMFiber
        else
          Object.const_get(ENV['DO_M_ENGINE'])
        end
      end

      def do_m(klass, &blk)
        engine.do_m(klass, &blk)
      end
    end
  end
end

