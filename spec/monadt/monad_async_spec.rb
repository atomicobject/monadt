require_relative 'monad_async_example'
require 'monadt/async'

describe 'async monad' do
  it 'handles correct cases' do
    result = Monadt::AsyncExample.async_func(9)
    expect(result.resume).to eq(9 ** 10 + 10)

    result = Monadt::AsyncExample.async_func(-3)
    expect(result.resume).to eq(-3)
  end
end
