require_relative 'maybe'
require_relative 'either'
require_relative 'state'
require_relative 'reader_state_either'

class ListM
  class << self
    def bind(m, &blk)
      m.flat_map(&blk)
    end

    def return(a)
      [a]
    end
  end
end

