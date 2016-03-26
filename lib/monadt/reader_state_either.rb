module Monadt
  class ReaderStateEither
    class << self
      def bind(m, &blk)
        ->(e, s) {
          v, s2 = m.(e, s)
          if v.is_left
            blk.call(v.left).(e, s2)
          else
            [v, s2]
          end
        }
      end

      def return(val)
        ->(e, s) { [Either.return(val), s] }
      end
    end
  end
end
