require 'monadt/adt'

module Monadt
  module Either
    Left = data :left
    Right = data :right
  end
  class Either::Left
    def is_left?() true end
    def is_right?() false end
    def to_s() "Left(#{left})" end
  end
  class Either::Right
    def is_left?() false end
    def is_right?() true end
    def to_s() "Right(#{right})" end
  end

  class EitherM
    class << self
      include Adt

      def bind(m, &blk)
        match(m,
          with(Either::Left) { |v| m },
          with(Either::Right) { |v| blk.call(v) })
      end

      def return(a)
        Either::Right.new a
      end
    end

  end
end
