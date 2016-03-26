module Monadt
  class Either
    attr_reader :left, :right, :is_left

    def to_s
      if is_left
        "left: #{left}"
      else
        "right: #{right}"
      end
    end

    private
    def initialize(is_left, left_value, right_value)
      @is_left = is_left
      @left = left_value
      @right = right_value
    end

    class << self
      def left(val)
        Either.new true, val, nil
      end

      def right(val)
        Either.new false, nil, val
      end

      def bind(m, &blk)
        if !m.is_left
          m
        else
          blk.call(m.left)
        end
      end

      def return(a)
        left a
      end
    end

  end
end
