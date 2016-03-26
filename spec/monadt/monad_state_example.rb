require 'funkify'
require 'monadt/monad'
require 'util'

module Monadt
  class StateFuncs
    include Funkify

    auto_curry
    def unpack_english(base, state)
      v = Lang.english[state.first % base]
      [v, state.rest]
    end

    def unpack_spanish(base, state)
      v = Lang.spanish[state.first % base]
      [v, state.rest]
    end
  end

  class StateExample
    class << self
      def state_func(bytes)
        sf = StateFuncs.new
        Monad.run_state(bytes) do |m|
          a = m.bind (sf.unpack_english 4)
          b = m.bind (sf.unpack_english 6)
          c = m.bind (sf.unpack_spanish 5)
          d = m.bind (sf.unpack_spanish 2)
          m.return "#{a} and #{b} + #{c} y #{d}"
        end
      end
    end
  end
end
