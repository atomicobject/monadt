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

      def map_param(param)
        if param.is_a? Monadt::ListM
          param.to_a
        else
          [param]
        end
      end

      def lift_params(params)
        if params.size == 0
          nil
        else
          first = map_param params[0]
          rest = params.slice(1..-1)
          rest = lift_params rest
          if rest.nil?
            if first.is_a? Array
              first.map do |x| [x] end
            else
              [first]
            end
          else
            first.flat_map do |p0|
              rest.map do |p1n|
                [p0].concat p1n
              end
            end
          end
        end
      end

      def lift(prc, *params)
        p_delta = lift_params(params)
        ret = p_delta.flat_map do |ps|
          prc.call(*ps)
        end
        ListM.create ret
      end

      def list_func(v)
        lf = ListFuncs.new
        Monad.do_m(Monadt::ListM) do |m|
          x = m.bind (lift lf.list1, v)
          y = m.bind (lift lf.list2, x)
          Monadt::ListM.return (lift lf.add, x, y)
        end.to_a
      end

      def list_func_simple(v)
        lf = ListFuncs.new
        Monad.do_m(Monadt::ListM2) do |m|
          x = m.bind lf.list1(v)
          y = m.bind lf.list2(x)
          Monadt::ListM2.return lf.add(x, y)
        end.to_a
      end
    end
  end
end
