require_relative 'monad_async_either_example'
require 'monadt/async_either'

describe 'async either monad' do
  it 'handles correct cases' do
    result = Monadt::AsyncEitherExample.async_func_works().resume
    expect(result.is_right?).to be true
    expect(result.right).to eq({bar: 'baz'})

  end

  it 'stops early' do
    result = Monadt::AsyncEitherExample.async_func_short_circuit().resume
    expect(result.is_right?).to be false
    expect(result.left).to eq("URL www.fail.com/world could not be retrieved")
  end
end
