require 'monadt/maybe'
require 'monadt/either'
require 'monadt/state'
require 'monadt/reader_state_either'
require 'monadt/monad'

module Monadt
  class Monad
    class << self
      def maybe(&blk)
        do_m(MaybeM, &blk)
      end

      def present(&blk)
        do_m(PresentM, &blk)
      end

      def either(&blk)
        do_m(EitherM, &blk)
      end

      def state(&blk)
        do_m(StateM, &blk)
      end

      def run_state(initial_state, &blk)
        prc = state(&blk)
        prc.(initial_state).first
      end

      def reader(&blk)
        do_m(ReaderM, &blk)
      end

      def run_reader(env, &blk)
        reader(&blk).(env)
      end

      def reader_state_choice(&blk)
        do_m(ReaderStateEitherM, &blk)
      end

      def run_reader_state_choice(env, initial_state, &blk)
        reader_state_choice(&blk).(env, initial_state).first
      end
    end
  end
end

