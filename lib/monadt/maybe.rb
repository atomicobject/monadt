require 'monadt/adt'

module Monadt
  module Maybe
    Just = data :value
    Nothing = data
  end

  class Maybe::Just
    def is_nothing?() false end
    def to_s() "Just #{value}" end
  end
  class Maybe::Nothing
    def is_nothing?() true end
    def to_s() "Nothing" end
  end

  class MaybeM
    class << self
      include Adt

      def bind(m, &blk)
        match(m,
          with(Maybe::Just) { |v| blk.call(v) },
          with(Maybe::Nothing) { m })
      end

      def return(a)
        Maybe::Just.new a
      end
    end
  end

  # like Maybe but nil / not-nill
  class PresentM
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

