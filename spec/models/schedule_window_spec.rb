require 'rails_helper'

RSpec.describe ScheduleWindow, type: :model do
    let(:recurring_schedule_window) { build(:schedule_window, is_recurring: true, end_date: Date.today - 2.days) }
    let(:recurring_schedule_window1) { build(:schedule_window, end_time: DateTime.now - 10.hours) }
    let(:recurring_schedule_window2) { build(:schedule_window, is_recurring: true, start_date: Date.today + 1.day) }
    let(:recurring_schedule_window3) { build(:schedule_window, is_recurring: true, end_date: Date.today - 4.months) }

    describe "Validations" do
      it { should validate_presence_of(:start_time) }
      it { should validate_presence_of(:end_time) }

      context "When is_recurring false" do
        it { should_not validate_presence_of(:start_date) }
        it { should_not validate_presence_of(:end_date) }
      end

      context "When is_recurring true" do
        before { allow(subject).to receive(:is_recurring?).and_return(true) }
        it { should validate_presence_of(:start_date) }
        it { should validate_presence_of(:end_date) }
      end

      it "should validate start date cannot be later than end date" do
        expect(recurring_schedule_window.valid?).to be_falsey
      end

      it "should validate start time cannot be later than end time" do
        expect(recurring_schedule_window1.valid?).to be_falsey
      end

      it "should validate start date cannot be later than start time" do
        expect(recurring_schedule_window2.valid?).to be_falsey
      end

      it "should validate end date cannot be before end time" do
        expect(recurring_schedule_window3.valid?).to be_falsey
      end
    end

    describe "Associations" do
      it { should belong_to(:driver) }
      it { should have_one(:recurring_pattern) }
      it { should belong_to(:location) }
    end

    describe 'Cannot be in the past' do
      it "should validate that start time cannot be in the past" do
        subject.start_time = "2019-07-01"
        subject.valid?  # run validations
        expect(subject.errors[:start_time]).to include('cannot be in the past')
      end

      it "should validate that end time cannot be in the past" do
        subject.end_time = "2019-07-01"
        subject.valid?
        expect(subject.errors[:end_time]).to include('cannot be in the past')
      end

      it "should validate that start date cannot be in the past" do
        subject.start_date = "2019-07-01"
        subject.valid?  # run validations
        expect(subject.errors[:start_date]).to include('cannot be in the past')
      end

      it "should validate that end date cannot be in the past" do
        subject.end_date = "2019-07-01"
        subject.valid?
        expect(subject.errors[:end_date]).to include('cannot be in the past')
      end
    end

    describe 'Cannot be overlapped' do
      it "should validate that end time cannot be before start time" do
        subject.start_time = "2019-07-01 9:00am"
        subject.end_time = "2019-07-01 9:00am"
        subject.valid?  # run validations
        expect(subject.valid?).to be_falsey
      end

      it "should validate that end date cannot be before start date" do
        subject.start_time = "2019-07-01"
        subject.end_time = "2019-07-01"
        subject.valid?  # run validations
        expect(subject.valid?).to be_falsey
      end
    end
end
