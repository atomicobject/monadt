require 'monadt/adt'

# Proof of concept for modeling Business Domain with Nil/Null or Optional based on F# union types
#
# type RegistrationFlow =
#   | Accepted of confirmation_number: int
#   | CourseFull
#   | WaitingList if spot: int
#
# Example contract of method which depends on this type:
#
# let registerForCourse (course: Course) : RegistrationFlow = ...

class RegistrationFlow
  Accepted = data :confirmation_number, :full_name
  CourseFull = data
  WaitingList = data :spot
end

decorate_adt RegistrationFlow

class UseAdts
  include Adt

  def adt_func(o)
    match o,
      with(RegistrationFlow::Accepted, ->(confirmation_number:, full_name:) { confirmation_number.to_s + full_name.to_s }),
      with(RegistrationFlow::CourseFull, ->() { 10 }),
      with(Default, ->() { "default" })
  end

  def adt_func2(o)
    match o,
      with(RegistrationFlow::Accepted) { |confirmation_number:, full_name:| confirmation_number.to_s + full_name.to_s },
      with(RegistrationFlow::CourseFull) { 10 },
      with(Default) { "default" }
  end
end

describe 'Algebraic Data Types' do
  let(:v1) { RegistrationFlow.accepted confirmation_number: 1, full_name: :five }
  let(:v2) { RegistrationFlow.waiting_list spot: "hoi" }
  let(:v3) { RegistrationFlow.course_full }
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
      expect(v1.is_accepted?).to be true
      expect(v1.is_waiting_list?).to be false
      expect(v1.is_course_full?).to be false
      expect(v1.to_s).to eq("Accepted(1, five)")

      expect(v2.is_accepted?).to be false
      expect(v2.is_waiting_list?).to be true
      expect(v2.is_course_full?).to be false
      expect(v2.to_s).to eq("WaitingList(hoi)")

      expect(v3.is_accepted?).to be false
      expect(v3.is_waiting_list?).to be false
      expect(v3.is_course_full?).to be true
      expect(v3.to_s).to eq("CourseFull")
    end
  end
end
