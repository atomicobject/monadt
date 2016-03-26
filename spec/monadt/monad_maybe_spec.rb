require_relative 'monad_maybe_example'

describe 'maybe monad' do
  it 'handles correct cases' do
    result = Monadt::MaybeExample.maybe_func(5)
    expect(result.value).to eq(15)

    result = Monadt::MaybeExample.maybe_func(-4)
    expect(result.is_nothing?).to be true
  end

  it 'stops early' do
    result = Monadt::MaybeExample.maybe_func_stop_early(-4)
    expect(result.is_nothing?).to be true

    expect { Monadt::MaybeExample.maybe_func_stop_early(5) }.to raise_exception("uh oh")
  end
end

describe 'present monad' do
  it 'handles correct cases' do
    result = Monadt::PresentExample.maybe_func(5)
    expect(result).to eq(15)

    result = Monadt::PresentExample.maybe_func(-4)
    expect(result).to be nil
  end

  it 'stops early' do
    result = Monadt::PresentExample.maybe_func_stop_early(-4)
    expect(result).to be nil

    expect { Monadt::PresentExample.maybe_func_stop_early(5) }.to raise_exception("uh oh")
  end
end
