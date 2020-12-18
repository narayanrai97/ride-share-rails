require 'rails_helper'

RSpec.describe "RideCancellations", type: :request do

  describe "GET /show" do
    let!(:organization) {create :organization}
    let!(:ride_category) {create :ride_category, organization_id: organization.id}
    let!(:ride) {create :ride2, reasons_attributes: [details: "Interview", ride_category_id: ride_category.id]}
    it "returns http success" do
      get "/admin_ride/#{ride.id}/cancel"
      expect(response).to have_http_status(:success)
    end
  end

end
