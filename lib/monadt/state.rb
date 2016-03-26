module Monadt
  class State
    class << self
      # m : s -> v * s
      # blk : v -> (s -> u * s')
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
