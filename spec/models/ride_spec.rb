require 'rails_helper'

RSpec.describe Ride, type: :model do

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:pick_up_time) }
    it { is_expected.to validate_presence_of(:reasons) }
    it { is_expected.to validate_presence_of(:status) }
  end

   describe "Associations" do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to belong_to(:rider) }
    it { is_expected.to belong_to(:start_location) }
    it { is_expected.to belong_to(:end_location) }
    it { is_expected.to have_one(:token) }
  end

end
