require_relative 'monad_reader_state_either_example'

describe 'reader state either monad' do
  it 'handles correct cases' do
    val = Monadt::ReaderStateEitherExample.state_func(:english, [5,14,8])
    expect(val.is_right?).to be true
    expect(val.right).to eq("one, five, two")

    expect(val.is_right?).to be true
    val = Monadt::ReaderStateEitherExample.state_func(:spanish, [5,14,8])
    expect(val.right).to eq("uno, cinco, dos")
  end

  it 'stops early' do
    val = Monadt::ReaderStateEitherExample.state_func(:english, [5,8,8])
    expect(val.is_right?).to be false
    expect(val.left).to eq("too big")
  end
end
