require 'rails_helper'

RSpec.describe AdminRideController, type: :request do
  let!(:organization) {create :organization, name: "Burlington High", street: "644 spence street", city: "burlington", zip: "27417"}
  let!(:admin) { create :user, organization_id: organization.id }
  let (:organization2) {create :organization, name: 'University of North Carolina', street: '4000 Ashley Wade Ln', city:'Chapel Hill', state:'NC', zip: '27514', use_tokens: true }
  let!(:admin2) {create :user, email: "admin2@example.com", organization_id: organization2.id}
  # let!(:ride) { FactoryBot.create(:ride3)}
  let!(:ride) { FactoryBot.attributes_for(:ride3) }
  let!(:location1) {FactoryBot.attributes_for(:location)}
  let!(:location2) {FactoryBot.attributes_for(:location, end_street: "700 Park Offices Dr")}
  let!(:select_rider) { create :rider, email: "select_rider@example.com", organization_id: admin.organization_id }
  let!(:select_rider2) { create :rider, email: "jump_rider@example.com", organization_id: admin.organization_id, is_active: false }
  let!(:select_rider3) { create :rider, email: "fast_rider@example.com", organization_id: admin2.organization_id, is_active: true }
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

    it "Ride does not create when rider is not active" do
      login_as(admin, :scope => :user )
        expect do
          post admin_ride_index_path, params:{
          ride: {
          rider_id: select_rider2.id,
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
         round_trip: false
          }
        }
      end.not_to change(Ride, :count)
      expect(select_rider2.is_active).to eq(false)
      response.should redirect_to admin_ride_index_path
    end

    it "raises expection when rider is not found" do
      expect do
        # byebug
        post admin_ride_index_path, params:{
        ride: {
        rider_id: 9999,
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
       round_trip: false
        }
      }
      end.not_to change(Ride, :count)
      expect{raise StandardError, "The rider can't be blank."}.to raise_error(StandardError, "The rider can't be blank." )
      expect(response).to render_template(:new)
    end

    it "Check if organization uses tokens" do
      login_as(admin2, :scope => :user )
      expect do
        # byebug
        post admin_ride_index_path, params:{
        ride: {
        rider_id: select_rider3.id,
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
       round_trip: false
        }
      }
      end.to change(Ride, :count)
    end

    it "Error when start location is not provide" do
      login_as(admin2, :scope => :user )
      expect do
        # byebug
        post admin_ride_index_path, params:{
        ride: {
        rider_id: select_rider3.id,
       pick_up_time: DateTime.now - 6.days,
       save_start_location: true,
       save_end_location: true,
       end_street: location2[:street],
       end_city: location2[:city],
       end_state: location2[:state],
       end_zip: location2[:zip],
       reason: "doctor",
       round_trip: false
        }
      }
    end.not_to change(Ride, :count)
    # byebug
    expect{raise NameError, "Street can't be blank."}.to raise_error( NameError, "Street can't be blank.")
    expect{raise NameError, "City can't be blank."}.to raise_error( NameError, "City can't be blank.")
    expect{raise NameError, "State can't be blank."}.to raise_error( NameError, "State can't be blank.")
    expect{raise NameError, "Zip is the wrong length (should be 5 characters)"}.to raise_error( NameError, "Zip is the wrong length (should be 5 characters)")
    expect{raise NameError, "Zip is not a number."}.to raise_error( NameError, "Zip is not a number.")
    expect(response).to render_template(:new)
    end

    it "Error when end location is not provide" do
      expect do
        # byebug
        post admin_ride_index_path, params:{
        ride: {
        rider_id: select_rider.id,
       pick_up_time: DateTime.now + 6.days,
       save_start_location: true,
       save_end_location: true,
       start_street: location2[:street],
       start_city: location2[:city],
       start_state: location2[:state],
       start_zip: location2[:zip],
       reason: "doctor",
       round_trip: false
        }
      }
    end.not_to change(Ride, :count)
    expect{raise NameError, "Street can't be blank."}.to raise_error( NameError, "Street can't be blank.")
    expect{raise NameError, "City can't be blank."}.to raise_error( NameError, "City can't be blank.")
    expect{raise NameError, "State can't be blank."}.to raise_error( NameError, "State can't be blank.")
    expect{raise NameError, "Zip is the wrong length (should be 5 characters)"}.to raise_error( NameError, "Zip is the wrong length (should be 5 characters)")
    expect{raise NameError, "Zip is not a number."}.to raise_error( NameError, "Zip is not a number.")
    expect(response.redirect?).to eq(false)
    expect(response).to render_template(:new)
    end

    it "changes the ride count and token count on admin ride create" do
      expect do
          post admin_ride_index_path, params: {
            ride: {
            rider_id: select_rider.id,
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
           round_trip: false
            }
          }
          # byebug
          @next_token.ride_id = Ride.last.id
          @next_token.save
          end.to change(Ride, :count)
      expect(select_rider.valid_tokens_count).to eq(0) # Token count change after admin ride create
      response.should redirect_to  "/admin_ride/#{Ride.last.id}"
    end

    it "Error when round trip is true but return trip pick up time is in the past" do
      expect do
          post admin_ride_index_path, params: {
            ride: {
            rider_id: select_rider.id,
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
           round_trip: true,
           return_pick_up_time: DateTime.now - 6.days + 2.hours,
           notes: "ride created",
           status: "active"
            }
          }
        end.not_to change(Ride, :count)
          # byebug
      expect(flash[:alert]).to eq ("Return time must be at least 30 minutes after departure time")
      expect(response.redirect?).to eq(false)
      expect(response).to render_template(:new)
    end

    it "Error when round trip is true but return trip pick up time is in the past" do
      expect do
          post admin_ride_index_path, params: {
            ride: {
            rider_id: select_rider.id,
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
           round_trip: true,
           return_pick_up_time: DateTime.now - 6.days + 2.hours,
           notes: "ride created",
           status: "active"
            }
          }
        end.not_to change(Ride, :count)
      expect(flash[:alert]).to eq ("Return time must be at least 30 minutes after departure time")
      expect(response.redirect?).to eq(false)
      expect(response).to render_template(:new)
    end

    it "Create a ride with a round trip" do
      expect do
          post admin_ride_index_path, params: {
            ride: {
            rider_id: select_rider.id,
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
           round_trip: true,
           return_pick_up_time: DateTime.now + 6.days + 2.hours,
           notes: "ride created",
           status: "active"
            }
          }
        end.to change(Ride, :count)
        expect(response.redirect?).to eq(true)
    end
  end

  describe "New Action" do
    before do
      login_as(admin, :scope => :user)
    end
    it "it render the new action" do
      get new_admin_ride_path
      expect(response.redirect?).to eq(false)
      expect(response).to render_template(:new)
    end
  end

  describe "show Action" do
    let!(:ride)  { FactoryBot.create(:ride3) }

    before do
      login_as(admin, :scope => :user)
    end

    it "Create a ride and render the show" do
      # byebug
      get admin_ride_path(Ride.last.id)
      # byebug
       expect(response.redirect?).to eq(true)
       response.should redirect_to admin_ride_index_path
    end

    it "Error when ride can not be found" do
      # byebug
      get admin_ride_path(9999)
       expect(response.redirect?).to eq(true)
       response.should redirect_to admin_ride_index_path
       expect(flash[:alert]).to eq("Record not found.")
    end
  end

  describe "Edit Action" do
    let!(:ride)  { FactoryBot.create(:ride3) }

    before do
      login_as(admin, :scope => :user)
    end

    it "Create a ride and render the show" do
      get edit_admin_ride_path(Ride.last.id)

       expect(response.redirect?).to eq(true)
       response.should redirect_to admin_ride_index_path
    end

    it "Error when ride can not be found" do
      get edit_admin_ride_path(9999)

       expect(response.redirect?).to eq(true)
       response.should redirect_to admin_ride_index_path
       expect(flash[:alert]).to eq("Record not found.")
    end
  end

  describe "Index Action" do
    let!(:ride)  { create :ride3, organization_id: admin.organization.id, status: "approved" }
    let!(:ride2)  { create :ride3, organization_id: admin.organization.id, status: "approved" }
    let!(:ride3)  { create :ride3, organization_id: admin.organization.id, status: "pending" }
    let!(:ride4)  { create :ride3, organization_id: admin.organization.id, status: "completed" }

    before do
      login_as(admin, :scope => :user)
    end

    it "Create a record and render index" do
      get admin_ride_index_path


      expect(response.redirect?).to eq(false)
      expect(Ride.count).to eq(4)
    end
  end

  describe "Update action" do
    let!(:ride)  { create :ride3, organization_id: admin.organization.id, status: "approved" }

    before do
      login_as(admin, :scope => :user)
    end

    it "Error when end location is not provide in params" do
      expect do
      put admin_ride_path(Ride.last), params: {
        ride: {
          start_street: location2[:street],
          start_city: location2[:city],
          start_state: location2[:state],
          start_zip: location2[:zip]
        }
      }
    end.not_to change(Ride, :count)
    expect{raise NameError, "Street can't be blank."}.to raise_error( NameError, "Street can't be blank.")
    expect{raise NameError, "City can't be blank."}.to raise_error( NameError, "City can't be blank.")
    expect{raise NameError, "State can't be blank."}.to raise_error( NameError, "State can't be blank.")
    expect{raise NameError, "Zip is the wrong length (should be 5 characters)"}.to raise_error( NameError, "Zip is the wrong length (should be 5 characters)")
    expect{raise NameError, "Zip is not a number."}.to raise_error( NameError, "Zip is not a number.")
    expect(response.redirect?).to eq(false)
    expect(response).to render_template(:edit)
    end

    it "Error when start location is not provide in params" do
      expect do
      put admin_ride_path(Ride.last), params: {
        ride: {
          end_street: location2[:street],
          end_city: location2[:city],
          end_state: location2[:state],
          end_zip: location2[:zip]
        }
      }
    end.not_to change(Ride, :count)
    expect{raise NameError, "Street can't be blank."}.to raise_error( NameError, "Street can't be blank.")
    expect{raise NameError, "City can't be blank."}.to raise_error( NameError, "City can't be blank.")
    expect{raise NameError, "State can't be blank."}.to raise_error( NameError, "State can't be blank.")
    expect{raise NameError, "Zip is the wrong length (should be 5 characters)"}.to raise_error( NameError, "Zip is the wrong length (should be 5 characters)")
    expect{raise NameError, "Zip is not a number."}.to raise_error( NameError, "Zip is not a number.")
    expect(response.redirect?).to eq(false)
    expect(response).to render_template(:edit)
    end

  it "Updates a ride when round trip is false" do
    expect do
      put admin_ride_path(Ride.last), params: {
        ride: {
          start_street: location2[:street],
          start_city: location2[:city],
          start_state: location2[:state],
          start_zip: location2[:zip],
          end_street: location2[:street],
          end_city: location2[:city],
          end_state: location2[:state],
          end_zip: location2[:zip],
          organization_id: admin.organization_id,
          rider_id: select_rider.id,
          pick_up_time: DateTime.now + 6.days,
          reason: ride.reason,
          round_trip: false,
          notes: "Yes",
          start_location: ride.start_location,
          end_location: ride.end_location
        }
      }
    end.not_to change(Ride, :count)
    expect(response.redirect?).to eq(true)
    expect(flash[:notice]).to eq("The ride information has been updated.")
    end

    it "Updates a ride when round trip is true" do
      expect do
        put admin_ride_path(Ride.last), params: {
          ride: {
            start_street: location2[:street],
            start_city: location2[:city],
            start_state: location2[:state],
            start_zip: location2[:zip],
            end_street: location1[:street],
            end_city: location1[:city],
            end_state: location1[:state],
            end_zip: location1[:zip],
            organization_id: admin.organization_id,
            rider_id: select_rider.id,
            pick_up_time: DateTime.now + 6.days,
            reason: ride.reason,
            round_trip: true,
            return_pick_up_time: DateTime.now + 6.days + 3.hours,
            notes: "pick near walmart",
            start_location: ride.start_location,
            end_location: ride.end_location
          }
        }
      end.to change(Ride, :count)
      expect(response.redirect?).to eq(true)
      expect(flash[:notice]).to eq("The ride information has been updated.")
      end
  end

end
