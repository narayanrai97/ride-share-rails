require 'rails_helper'

RSpec.describe Vehicle, type: :model do

  describe "Validations" do
      it { is_expected.to validate_presence_of(:car_make) }
      it { is_expected.to validate_presence_of(:car_model) }
      it { is_expected.to validate_presence_of(:car_color) }
      it { is_expected.to validate_presence_of(:car_year) }
      it { is_expected.to validate_presence_of(:car_plate) }
      it { is_expected.to validate_presence_of(:seat_belt_num) }
      it { is_expected.to validate_presence_of(:insurance_provider) }
  end

  describe "Associations" do
      it { is_expected.to belong_to(:driver) }
  end

end
