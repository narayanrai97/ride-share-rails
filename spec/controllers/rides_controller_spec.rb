require 'rails_helper'

RSpec.describe RidesController, type: :controller do
  let!(:organization) { create :organization, use_tokens: true }
  let!(:rider) { create :rider, email: "noemail@example.com", organization_id: organization.id }
  let!(:valid_tokens) { create_list :token, 5, rider_id: rider.id }
  let!(:pick_up_time) { Time.zone.now + 15.days }

  describe "POST create" do
    before do
      sign_in rider
      @next_token = rider.next_valid_token       # Token id `1`
    end

    let(:test_response) { post :create, params: { ride: { rider_id: rider.id,
                                                          pick_up_time: pick_up_time,
                                                          start_street: "201 W. Main st.",
                                                          start_city: "Durham",
                                                          start_state: "NC",
                                                          start_zip: "27701",
                                                          end_street: "1200 Foster st.",
                                                          end_city: "Durham",
                                                          end_state: "NC",
                                                          end_zip: "27705",
                                                          reason: "Doctor visit",
                                                          status: "approved",
                                                          round_trip: false
                                                        }
                                                  }
                            }

    xit "changes the ride count on ride create" do

      expect do                                # first expect
          test_response
          @next_token.ride_id = Ride.last.id
          @next_token.save
      end.to change(Ride, :count)

      expect(rider.valid_tokens_count).to eq(4) # expecting Token count change after ride create
    end

  end
end
