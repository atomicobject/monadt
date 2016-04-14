require 'monadt/adt'

module Monadt

  class Multiverse
    Multi = data :verses
    Single = data :value
  end

  Verse = Struct.new :values, :parent

  class << self
    include Adt

    def bind(m, &blk)
      match m,
        with(Multi) { |verses|
          Multiverse.multi(verses.map { |verse|
            verse.values.map { |value|
              Verse.new(blk.call(value), m)
            }
          })
        },
        with(Single) { |value|
          Multiverse.multi([Verse.new(blk.call(value), m)])
        }
    end

    def return(a)
      Multiverse.single a
    end

    def initialize(seed,f = nil)
      if seed.is_a? Multiverse
        @parent = [seed,f]
      else
        @raw = seed
      end
    end

    def transform(f)
      Multiverse.new(self, f)
    end

    def realize
      if @raw.nil?
        @raw
      else
        f.call(seed)
      end
    end
  end

  decorate_adt Multiverse

  class ListM
    def initialize(a)
      @list = a
    end

    def to_a
      @list
    end

    class << self

      def create(a)
        if a.is_a? ListM
          a
        elsif a.is_a? Array
          ListM.new a
        else
          ListM.new [a]
        end
      end

      def bind(m, &blk)
        blk.call(ListM.create m)
        #m.flat_map(&blk)
      end

      def return(a)
        ListM.create a
        #[a]
      end
    end
  end

  class ListM2
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
