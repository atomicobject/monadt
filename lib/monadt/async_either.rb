require 'monadt/adt'
require 'monadt/either'
require 'pry'

module Monadt
  class AsyncEither
    class << self
      include Adt

      def bind(m, &blk)
        binding.pry
        a = m.resume
        match(a,
          with(Either::Left) { |v| m },
          with(Either::Right) { |v|
            binding.pry
            blk.call(v)
        })
      end

      def return(a)
        Async.return(Either.return(a))
      end
    end
  end
end
