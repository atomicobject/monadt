require_relative 'maybe'
require_relative 'either'
require_relative 'state'
require_relative 'reader_state_either'

class List
  class << self
    def bind(m, &blk)
      m.flat_map(&blk)
    end

    def return(a)
      [a]
    end
  end
end

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

module Monadt
  class Monad
    class << self
      def doM(klass, &blk)
        e = Enumerator.new do |y|
          m_obj = MonadObj.new klass, y
          blk.call(m_obj)
        end
        magic_thing(klass, e)
      end

      def magic_thing(klass, e)
        begin
          ma = e.next
        rescue StopIteration => ex
          return ex.result
        end
        klass.bind(ma) do |a|
          e.feed a
          magic_thing(klass, e)
        end
      end

      def maybe(&blk)
        doM(Maybe, &blk)
      end

      def either(&blk)
        doM(Either, &blk)
      end

      def state(initial_state, &blk)
        f = doM(State, &blk)
        f.(initial_state).first
      end

      def reader(env, &blk)
        doM(Reader, &blk).(env)
      end

      def reader_state_choice(env, initial_state, &blk)
        doM(ReaderStateEither, &blk).(env, initial_state).first
      end
    end
  end
end

