require 'rails_helper'

RSpec.describe Vehicle, type: :model do

  describe "Validations" do
      it { should validate_presence_of(:car_make) }
      it { should validate_presence_of(:car_model) }
      it { should validate_presence_of(:car_color) }
      it { should validate_presence_of(:car_year) }
      it { should validate_presence_of(:car_plate) }
      it { should validate_presence_of(:seat_belt_num) }
      it { should validate_presence_of(:insurance_provider) }
      it { should validate_presence_of(:insurance_start) }
      it { should validate_presence_of(:insurance_stop) }
  end

  describe "Associations" do
      it { should belong_to(:driver) }
  end

end
