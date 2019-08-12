require 'rails_helper'

RSpec.describe Ride, type: :model do

  describe 'Validations' do
    it { should validate_presence_of(:pick_up_time) }
    it { should validate_presence_of(:reason) }
    it { should validate_presence_of(:status) }
  end

   describe "Associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:rider) }
    it { should belong_to(:start_location) }
    it { should belong_to(:end_location) }
    it { should have_one(:token) }
  end

end
