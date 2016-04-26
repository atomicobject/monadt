require 'monadt/maybe'
require 'monadt/either'
require 'monadt/async'
require 'monadt/state'
require 'monadt/async_either'
require 'monadt/reader_state_either'
require 'monadt/do_m'

module Monadt
  class Monad
    class << self
      def maybe(&blk)
        do_m(Maybe, &blk)
      end

      def present(&blk)
        do_m(Present, &blk)
      end

      def either(&blk)
        do_m(Either, &blk)
      end

      def async(&blk)
        do_m(Async, &blk)
      end

      def async_either(&blk)
        do_m(AsyncEither, &blk)
      end

      def state(&blk)
        do_m(State, &blk)
      end

      def run_state(initial_state, &blk)
        prc = state(&blk)
        prc.(initial_state).first
      end

      def reader(&blk)
        do_m(Reader, &blk)
      end

      def run_reader(env, &blk)
        reader(&blk).(env)
      end

      def reader_state_choice(&blk)
        do_m(ReaderStateEither, &blk)
      end

      def run_reader_state_choice(env, initial_state, &blk)
        reader_state_choice(&blk).(env, initial_state).first
      end
    end
  end
end

