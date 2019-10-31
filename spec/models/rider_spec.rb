require 'rails_helper'

RSpec.describe Rider, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.create(:rider)).to be_valid
  end

  let!(:rider) { create :rider, email: "new_email@example.com" }
  let!(:token) { create :token, expires_at: Date.today, rider_id: rider.id }
  let!(:tokens) { create_list :token, 5, rider_id: rider.id }
#   let(:token1) { create :token }

  describe "Validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:phone) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:tokens) }
    it { is_expected.to have_many(:rides) }
  end

  describe "Instance methods" do  # INSTANCE METHODS TESTS
    it "returns rider's full name" do
        expect(rider.full_name).to eq("Ubber Rider")
    end

    it "returns all valid tokens" do
        expect(rider.valid_tokens.to_a).to eq(tokens.insert(0, token))
    end

    it "returns a valid token that is expiring soon" do
        expect(rider.next_valid_token).to eq(token)
    end

    it "returns count of rider's valid tokens" do
        expect(rider.valid_tokens_count).to eq(6)
    end
  end

end
