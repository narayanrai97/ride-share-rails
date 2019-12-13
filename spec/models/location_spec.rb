require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:location) { create :location }
  it "has a valid factory" do
    expect(FactoryBot.create(:location)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:street) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:zip) }
    it { is_expected.not_to allow_value("zipCode").for(:zip) }
    it { is_expected.to validate_length_of(:zip).is_equal_to(5) }
  end

  describe "Associations" do
    it { is_expected.to have_many(:location_relationships) }
    it { is_expected.to have_many(:schedule_windows) }
    it { is_expected.to have_many(:drivers) }
  end

  describe 'Instance methods' do
    it "returns a location's full address as string" do
      expect(location.full_address).to eq("800 Park Offices Dr, Research Triangle, NC 27560")
    end
  end

end
