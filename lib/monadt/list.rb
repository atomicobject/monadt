require 'monadt/adt'

module Monadt
  class ListM
    class << self

      def bind(m, &blk)
        m.flat_map(&blk)
      end

      def return(a)
        [a]
      end

      def do_m(e, e_start = nil, history=[])
        if e_start.nil?
          e_start = e.dup
        end
        begin
          ma = e.next
        rescue StopIteration => ex
          return ex.result
        end
        zipped = ma.map do |a|
          my_e = e_start.dup
          history.each do |h|
            my_e.next
            my_e.feed h
          end
          my_e.next
          my_e.feed a
          [a, my_e]
        end

        zipped.flat_map do |(a, my_e)|
          h = history + [a]
          do_m(my_e, e_start, h)
        end
      end
    end
  end
end
