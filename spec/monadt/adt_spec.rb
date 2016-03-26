require 'monadt/adt'

class TestAdt
  One = data :foo, :bar
  Two = data :foo
  Three = data
end

decorate_adt TestAdt

class UseAdts
  include Adt

  def adt_func(o)
    match o,
      with(TestAdt::One, ->(foo, bar) { foo.to_s + bar.to_s }),
      with(TestAdt::Three, ->() { 10 }),
      with(Default, ->() { "default" })
  end

  def adt_func2(o)
    match o,
      with(TestAdt::One) { |foo, bar| foo.to_s + bar.to_s },
      with(TestAdt::Three) { 10 },
      with(Default) { "default" }
  end
end

describe 'Algebraic Data Types' do
  let(:v1) { TestAdt.one 1, :five }
  let(:v2) { TestAdt.two "hoi" }
  let(:v3) { TestAdt.three }
  let(:subject) { UseAdts.new }

  describe 'proc/block based ADTs' do

    it 'supports procs' do
      expect(subject.adt_func(v1)).to eq("1five")
      expect(subject.adt_func(v2)).to eq("default")
      expect(subject.adt_func(v3)).to eq(10)
    end

    it 'supports blocks' do
      expect(subject.adt_func2(v1)).to eq("1five")
      expect(subject.adt_func2(v2)).to eq("default")
      expect(subject.adt_func2(v3)).to eq(10)
    end
  end

  describe "decorate ADTs" do
    it 'supports blocks' do
      expect(v1.is_one?).to be true
      expect(v1.is_two?).to be false
      expect(v1.is_three?).to be false
      expect(v1.to_s).to eq("One(1, five)")

      expect(v2.is_one?).to be false
      expect(v2.is_two?).to be true
      expect(v2.is_three?).to be false
      expect(v2.to_s).to eq("Two(hoi)")

      expect(v3.is_one?).to be false
      expect(v3.is_two?).to be false
      expect(v3.is_three?).to be true
      expect(v3.to_s).to eq("Three")
    end
  end
end
