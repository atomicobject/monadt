require_relative 'monad_list_example'

describe 'list monad' do
  def expected(lf, v)
    lf.list1(v).flat_map do |x|
      lf.list2(x).flat_map do |y|
        lf.add(x, y)
      end
    end
  end

  it 'tries all the possibilities' do
    lf = ListFuncs.new

    result = Monadt::ListExample.list_func(9)
    expected = expected(lf, 9)
    expect(result).to eq(expected)

    result = Monadt::ListExample.list_func(3)
    expected = expected(lf, 3)
    expect(result).to eq(expected)

    result = Monadt::ListExample.list_func(10)
    expected = expected(lf, 10)
    expect(result).to eq(expected)
  end
end
