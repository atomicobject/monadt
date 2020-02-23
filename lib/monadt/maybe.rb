require 'monadt/adt'

module Monadt
  class Maybe
    Just = data :value, key_struct: false
    Nothing = data key_struct: false

    class << self
      include Adt

      def bind(m, &blk)
        match(m,
          with(Just) { |v| blk.call(v) },
          with(Nothing) { m })
      end

      def return(a)
        Maybe.just a
      end
    end
  end
  decorate_adt Maybe

  # like Maybe but nil / not-nill
  class Present
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

