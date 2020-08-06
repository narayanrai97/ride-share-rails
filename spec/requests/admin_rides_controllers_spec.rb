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
  # byebug
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
         round_trip: false,
         return_pick_up_time: DateTime.now + 6.days + 2.hours,
         notes: "ride created",
         status: "active"
          }
        }
      end.not_to change(Ride, :count)
      expect(select_rider2.is_active).to eq(false)
      # byebug
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
       round_trip: false,
       return_pick_up_time: DateTime.now + 6.days + 2.hours,
       notes: "ride created",
       status: "active"
        }
      }
      end.not_to change(Ride, :count)
      expect{raise StandardError, "The rider can't be blank."}.to raise_error(StandardError, "The rider can't be blank." )
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
       round_trip: false,
       return_pick_up_time: DateTime.now + 6.days + 2.hours,
       notes: "ride created",
       status: "active"
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
       round_trip: false,
       return_pick_up_time: DateTime.now + 6.days + 2.hours,
       notes: "ride created",
       status: "active"
        }
      }
    end.not_to change(Ride, :count)
    # byebug
    expect{raise NameError, "Street can't be blank."}.to raise_error( NameError, "Street can't be blank.")
    expect{raise NameError, "City can't be blank."}.to raise_error( NameError, "City can't be blank.")
    expect{raise NameError, "State can't be blank."}.to raise_error( NameError, "State can't be blank.")
    expect{raise NameError, "Zip is the wrong length (should be 5 characters)"}.to raise_error( NameError, "Zip is the wrong length (should be 5 characters)")
    expect{raise NameError, "Zip is not a number."}.to raise_error( NameError, "Zip is not a number.")
    end

    it "Error when end location is not provide" do
      expect do
        # byebug
        post admin_ride_index_path, params:{
        ride: {
        rider_id: select_rider3.id,
       pick_up_time: DateTime.now - 6.days,
       save_start_location: true,
       save_end_location: true,
       start_street: location2[:street],
       start_city: location2[:city],
       start_state: location2[:state],
       start_zip: location2[:zip],
       reason: "doctor",
       round_trip: false,
       return_pick_up_time: DateTime.now + 6.days + 2.hours,
       notes: "ride created",
       status: "active"
        }
      }
    end.not_to change(Ride, :count)
    expect{raise NameError, "Street can't be blank."}.to raise_error( NameError, "Street can't be blank.")
    expect{raise NameError, "City can't be blank."}.to raise_error( NameError, "City can't be blank.")
    expect{raise NameError, "State can't be blank."}.to raise_error( NameError, "State can't be blank.")
    expect{raise NameError, "Zip is the wrong length (should be 5 characters)"}.to raise_error( NameError, "Zip is the wrong length (should be 5 characters)")
    expect{raise NameError, "Zip is not a number."}.to raise_error( NameError, "Zip is not a number.")
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
           round_trip: false,
           return_pick_up_time: DateTime.now + 6.days + 2.hours,
           notes: "ride created",
           status: "active"
            }
          }
          # byebug
          @next_token.ride_id = Ride.last.id
          @next_token.save
          end.to change(Ride, :count)
      expect(select_rider.valid_tokens_count).to eq(0) # Token count change after admin ride create
      response.should redirect_to  "/admin_ride/#{ride.id}"
    end


  end

end
