require 'monadt/adt'

module Monadt
  class ReaderStateEitherM
    class << self
      include Adt

      def bind(m, &blk)
        ->(e, s) {
          c, s2 = m.(e, s)
          match(c,
            with(Either::Left) {|v| [c, s2]},
            with(Either::Right) {|v|
              blk.call(v).(e, s2)
            })
        }
      end

      def return(val)
        ->(e, s) { [EitherM.return(val), s] }
      end
    end
  end
end
