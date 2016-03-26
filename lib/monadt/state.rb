module Monadt
  class State
    class << self
      def bind(m, &blk)
        ->(st) {
          v, s = m.(st)
          blk.call(v).(s)
        }
      end

      def return(val)
        ->(st) { [val, st] }
      end
    end
  end
end
