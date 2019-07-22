require 'rails_helper'

RSpec.describe ScheduleWindow, type: :model do
    # it "has valid factory" do
    #     FactoryBot.create(:schedule_window).should be_valid
    # end
    let(:recurring_schedule_window) { build(:schedule_window, is_recurring: true, start_date: "") }
    let(:recurring_schedule_window2) { build(:schedule_window, is_recurring: true, end_date: "") }

    describe "Validations" do
      it { should validate_presence_of(:start_time) }
      it { should validate_presence_of(:end_time) }

      it "should validate presence of start date" do
        expect(recurring_schedule_window.valid?).to be_falsey
      end

      it "should validate presence of end date" do
        expect(recurring_schedule_window2.valid?).to be_falsey
      end
    end

    describe "Associations" do
      it { should belong_to(:driver) }
      it { should have_one(:recurring_pattern) }
      it { should belong_to(:location) }
    end
end
