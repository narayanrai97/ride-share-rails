require 'rails_helper'

RSpec.describe "RideCancellations", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/ride_cancellations/show"
      expect(response).to have_http_status(:success)
    end
  end

end
