require 'monadt/adt'

module Monadt
  class Either
    Left = data :left, key_struct: false
    Right = data :right, key_struct: false

    class << self
      include Adt

      def bind(m, &blk)
        match(m,
          with(Left) { |v| m },
          with(Right) { |v| blk.call(v) })
      end

      def return(a)
        right a
      end
    end

  end

  decorate_adt Either
end

