require 'rails_helper'

RSpec.describe AdminRideController, type: :request do
  let!(:admin) { create :user }
  # let!(:ride) { FactoryBot.create(:ride3)}
  let!(:ride) { FactoryBot.attributes_for(:ride3) }
  let!(:location1) {FactoryBot.attributes_for(:location)}
  let!(:location2) {FactoryBot.attributes_for(:location)}
  # byebug
  let!(:select_rider) { create :rider, email: "select_rider@example.com", organization_id: admin.organization_id }
  let!(:valid_tokens) { create_list :token, 5, rider_id: select_rider.id }
  let!(:pick_up_time) { Time.zone.now + 15.days }

  describe "POST create" do
    before do
      login_as(admin, :scope => :user )
      i = 1
      valid_tokens.each do |vt|
          vt.update_attributes(ride_id: i + 1)
          i = i + 1
      end
      @next_token = select_rider.next_valid_token       # Token id `1`
      @next_token = select_rider.valid_tokens.create if @next_token.nil?
    end

    it "changes the ride count and token count on admin ride create" do
      expect do
          post admin_ride_index_path, params: {
            ride: {
            rider_id: 1,
           pick_up_time: DateTime.now + 6.days,
           save_start_location: true,
           save_end_location: true,
           start_street: location1[:street],
           start_city: location1[:city],
           start_state: location1[:state],
           start_zip: location1[:zip],
           end_street: location2[:street],
           end_city: location2[:city],
           end_state: location2[:state],
           end_zip: location2[:zip],
           reason: "doctor",
           round_trip: false,
           return_pick_up_time: DateTime.now + 6.days + 2.hours,
           notes: "ride created",
           status: "active"
            }
          }
          @next_token.ride_id = Ride.last.id
          @next_token.save
          end.to change(Ride, :count)
      expect(select_rider.valid_tokens_count).to eq(0) # Token count change after admin ride create
    end

  end
end
