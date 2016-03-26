require_relative 'monad_list_example'

describe 'list monad' do
  xit 'tries all the possibilities' do
    result = ListExample.list_func(9)
    expect(result.is_left).to be true
    expect(result.left).to eq(12)

    result = ListExample.list_func(3)
    expect(result.to eq([1,2,3,4]))

    result = ListExample.list_func(10)
    expect(result.to eq([1,2,3,4]))
  end
end
