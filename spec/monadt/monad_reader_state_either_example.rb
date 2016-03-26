require 'funkify'
require 'monadt'
require 'util'

module Monadt
  class ReaderStateEitherFuncs
    include Funkify

    auto_curry
    def unpack(base, language, state)
      modded = state.first % base
      if (modded > 5)
        [Either::Left.new('too big'), state.rest]
      else
        v = Lang.send(language)[modded]
        [Either::Right.new(v), state.rest]
      end
    end

  end

  class ReaderStateEitherExample
    class << self
      def state_func(language, bytes)
        sf = ReaderStateEitherFuncs.new
        Monad.run_reader_state_choice(language, bytes) do |m|
          x = m.bind (sf.unpack 4)
          y = m.bind (sf.unpack 9)
          z = m.bind (sf.unpack 3)
          m.return "#{x}, #{y}, #{z}"
        end
      end
    end
  end
end
