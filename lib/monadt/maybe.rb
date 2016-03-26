module Monadt
  class Maybe
    class << self
      def bind(m, &blk)
        if m.nil?
          nil
        else
          blk.call(m)
        end
      end

      def return(a)
        a
      end
    end
  end
end

