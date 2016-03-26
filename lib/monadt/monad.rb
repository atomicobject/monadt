require_relative 'maybe'
require_relative 'either'
require_relative 'state'
require_relative 'reader_state_either'


module Monadt
  module Internal
    class MonadObj
      def initialize(klass, yielder)
        @yielder = yielder
        @klass = klass
      end

      def return(val)
        @klass.return val
      end

      def bind(val)
        @yielder.yield val
      end
    end
  end

  class Monad
    class << self
      def do_m(klass, &blk)
        e = Enumerator.new do |y|
          m_obj = Internal::MonadObj.new klass, y
          blk.call(m_obj)
        end
        do_m_recur(klass, e)
      end

      def do_m_recur(klass, e)
        begin
          ma = e.next
        rescue StopIteration => ex
          return ex.result
        end
        klass.bind(ma) do |a|
          e.feed a
          do_m_recur(klass, e)
        end
      end

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

