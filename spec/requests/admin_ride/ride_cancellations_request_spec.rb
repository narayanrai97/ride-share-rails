require 'rails_helper'

RSpec.describe "AdminRide::RideCancellations", type: :request do
  let!(:organization) { create :organization }
  let!(:admin) { create :user, organization_id: organization.id }

  describe "GET /review" do
    let!(:ride)  { create :ride2 }

    before do
      login_as(admin, :scope => :user)
    end

    it "Create a ride and render the show" do
       get review_admin_ride_path(ride.id)
       expect(response).to have_http_status(:success)
    end

    it "Error when ride can not be found" do
       get review_admin_ride_path(9999)
       expect(response.redirect?).to eq(true)
       response.should redirect_to admin_ride_index_path
       expect(flash[:alert]).to eq("Record not found.")
    end
  end

  describe "GET /cancel" do
    let!(:ride)  { create :ride2 }

    before do
      login_as(admin, :scope => :user)
    end

    it "Updates a ride when cancellation_reason is provided in params" do
      patch cancel_admin_ride_path(ride), params: {
        ride: {
          cancellation_reason: "No Show"
        }
      }
      ride.reload
      expect(ride.cancellation_reason).to eq "No Show"
    end

    it "Error when cancellation_reason is not provide in params" do
      expect do
      patch cancel_admin_ride_path(ride), params: {
        ride: {
          cancellation_reason: nil
        }
      }
      end.not_to change(Ride, :count)
      expect{raise NameError, "Cancellation reason can't be blank."}.to raise_error( NameError, "Cancellation reason can't be blank.")
    end
  end

end
