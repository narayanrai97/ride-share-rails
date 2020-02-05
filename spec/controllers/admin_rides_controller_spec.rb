require 'rails_helper'

RSpec.describe AdminRideController, type: :controller do
  let!(:admin) { create :user }
  let!(:select_rider) { create :rider, email: "select_rider@example.com", organization_id: admin.organization_id }
  let!(:valid_tokens) { create_list :token, 5, rider_id: select_rider.id }
  let!(:pick_up_time) { Time.zone.now + 15.days }

  describe "POST create" do
    before do
      sign_in admin
      i = 1
      valid_tokens.each do |vt|
          vt.update_attributes(ride_id: i + 1)
          i = i + 1
      end
      @next_token = select_rider.next_valid_token       # Token id `1`
      @next_token = select_rider.valid_tokens.create if @next_token.nil?
    end

    let(:test_response) { post :create, params: { ride: { rider_id: select_rider.id,
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
                                                          round_trip: true,
                                                          expected_wait_time: 45
                                                        }
                                                  }
                            }

    it "changes the ride count and token count on admin ride create" do

      expect do
          test_response
          @next_token.ride_id = Ride.last.id
          @next_token.save
      end.to change(Ride, :count)

      expect(select_rider.valid_tokens_count).to eq(0) # Token count change after admin ride create
    end

  end
end
