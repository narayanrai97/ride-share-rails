require 'rails_helper'

RSpec.describe Organization, type: :model do

  it "has a valid factory" do
    expect(FactoryBot.create(:organization)).to be_valid
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:street) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:zip) }
    # it { should validate_inclusion_of(:use_tokens).in_array([true, false]) }

    # ************************************************************************
    # Warning from shoulda-matchers:

    # You are using `validate_inclusion_of` to assert that a boolean column
    # allows boolean values and disallows non-boolean ones. Be aware that it
    # is not possible to fully test this, as boolean columns will
    # automatically convert non-boolean values to boolean ones. Hence, you
    # should consider removing this test.
    # ***********************************************************************
  end

  describe "Associations" do
    it { is_expected.to have_many(:drivers) }
    it { is_expected.to have_many(:riders) }
    it { is_expected.to have_many(:rides) }
  end

end
