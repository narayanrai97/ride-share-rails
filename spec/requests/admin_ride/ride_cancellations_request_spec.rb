require 'rails_helper'

RSpec.describe "AdminRide::RideCancellations", type: :request do

  describe "GET /review" do
    it "returns http success" do
      get "/admin_ride/ride_cancellations/review"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /cancel" do
    it "returns http success" do
      get "/admin_ride/ride_cancellations/cancel"
      expect(response).to have_http_status(:success)
    end
  end

end
