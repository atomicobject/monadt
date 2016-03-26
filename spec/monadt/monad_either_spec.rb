require_relative 'monad_either_example'
require 'monadt/either'

describe 'either monad' do
  it 'handles correct cases' do
    result = Monadt::EitherExample.either_func(9)
    expect(result.is_right?).to be true
    expect(result.right).to eq(12)

    result = Monadt::EitherExample.either_func(3)
    expect(result.is_right?).to be false
    expect(result.left).to eq("less than 5")

    result = Monadt::EitherExample.either_func(10)
    expect(result.is_right?).to be false
    expect(result.left).to eq("i need even numbers")
  end

  it 'stops early' do
    result = Monadt::EitherExample.either_func_stop_early(3)
    expect(result.is_right?).to be false
    expect(result.left).to eq("less than 5")

    expect { Monadt::EitherExample.either_func_stop_early(9) }.to raise_exception("uh oh")
  end
end
