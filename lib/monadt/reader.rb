module Monadt
  class Reader
    class << self
      def bind(m, &blk)
        ->(e) {
          v = m.(e)
          blk.call(e, v)
        }
      end

      def return(val)
        ->(e) { val }
      end
    end
  end
end
