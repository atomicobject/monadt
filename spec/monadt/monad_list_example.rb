require 'monadt'
require 'monadt/list'
require 'funkify'
require 'pry'

class ListFuncs
  include Funkify

  auto_curry
  def list1(x)
    #Choice.failure "no"
    if x > 5
      [x - 5, x]
    else
      [x, x + 2]
    end
  end

  auto_curry
  def list2(z)
    if z % 2 == 0
      [z, z / 2]
    else
      [z, z * 2]
    end
  end

  auto_curry
  def add(x,y)
    x + y
  end
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
