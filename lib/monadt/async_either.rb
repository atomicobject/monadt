require 'monadt/adt'
require 'monadt/either'
require 'pry'

module Monadt
  class AsyncEither
    class << self
      include Adt

      def bind(m, &blk)
        a = m.resume
        match(a,
          with(Either::Left) { |v| Async.return a },
          with(Either::Right) { |v|
            m2 = blk.call(v)
            if m2.alive?
              m2
            else
              Async.return a
            end
          })
      end

      def return(a)
        Async.return(Either.return(a))
      end
    end
  end
end
