require 'monadt'
require 'monadt/list'
require 'funkify'
require 'pry'
require 'memoist'

class ListFuncs
  extend Memoist

  def list1(x)
    #Choice.failure "no"
    if x > 5
      [x - 5, x]
    else
      [x, x + 2]
    end
  end
  memoize :list1

  def list2(z)
    if z % 2 == 0
      [z, z / 2]
    else
      [z, z * 2]
    end
  end
  memoize :list2

  def add(x,y)
    x + y
  end
  memoize :add
end

module Monadt
  class ListExample
    class << self
      def list_func(v)
        lf = ListFuncs.new
        Monad.do_m(Monadt::ListM) do |m|
          x = m.bind lf.list1(v)
          y = m.bind lf.list2(x)
          Monadt::ListM.return lf.add(x, y)
        end.to_a
      end
    end
  end
end
