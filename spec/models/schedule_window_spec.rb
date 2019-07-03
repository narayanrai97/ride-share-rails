require 'rails_helper'

RSpec.describe ScheduleWindow, type: :model do
    # it "has valid factory" do
    #     FactoryBot.create(:schedule_window).should be_valid
    # end

    describe "Validations" do
      it { should validate_presence_of(:start_time) }
      it { should validate_presence_of(:end_time) }
      it { should validate_presence_of(:is_recurring) }
    end

    describe "Associations" do
      it { should belong_to(:driver) }
      it { should have_one(:recurring_pattern) }
      it { should belong_to(:location) }
    end
end
