require 'rails_helper'

RSpec.describe RidesController, type: :controller do
  let!(:rider) { create :rider, email: "noemail@example.com" }
  let!(:valid_tokens) { create_list :token, 10, rider_id: rider.id }
  let!(:pick_up_time) { Time.zone.now + 15.days }
  let!(:start_location) { create :location }
  let!(:end_location) { create :location, street: "201 W. Main st", city: "Durham", state: "NC", zip: "27701" }

  describe "POST create" do
    before { sign_in rider }

    let(:test_response) { post :create, params: { ride: {rider_id: rider.id,
                                                pick_up_time: pick_up_time,
                                                start_location_id: start_location.id,
                                                end_location_id: end_location.id,
                                                reason: "Doctor visit",
                                                status: "requested"
                                              }
                                        }
                  }

    it "changes the ride count on ride create" do
      expect do
          test_response
      end.to change(Ride, :count)
    end

  end
end
