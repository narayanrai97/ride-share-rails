require 'rails_helper'

RSpec.describe AdminRideController, type: :request do
  let!(:admin) { create :user, organization_id: organization.id,
                  auth_token: "1234", token_created_at: Time.zone.now)} }
  # let!(:ride) { FactoryBot.create(:ride3)}
  let(:ride) { FactoryBot.attributes_for(:ride3) }
  # byebug
  let!(:select_rider) { create :rider, email: "select_rider@example.com", organization_id: admin.organization_id }
  let!(:valid_tokens) { create_list :token, 5, rider_id: select_rider.id }
  let!(:pick_up_time) { Time.zone.now + 15.days }

  describe "POST create" do
    before do
      # byebug
      sign_in admin, scope: :user
       byebug
      i = 1
      valid_tokens.each do |vt|
          vt.update_attributes(ride_id: i + 1)
          i = i + 1
      end
      @next_token = select_rider.next_valid_token       # Token id `1`
      @next_token = select_rider.valid_tokens.create if @next_token.nil?
    end
    # byebug
    # let(:test_response) { post :create, params: { ride: ride }}

      # byebug
    it "changes the ride count and token count on admin ride create" do

      expect do
        byebug
          # test_response
          post admin_ride_index_path, params: {ride: ride}
          # byebug
          @next_token.ride_id = Ride.last.id
          @next_token.save
      end.to change(Ride, :count)

      expect(select_rider.valid_tokens_count).to eq(0) # Token count change after admin ride create
    end

  end
end
