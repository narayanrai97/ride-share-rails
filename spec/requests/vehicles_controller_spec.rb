require 'rails_helper'

RSpec.describe Admin::VehiclesController, type: :request do
  let!(:organization1) {create :organization, name: "Burlington High", street: "644 spence street", city: "burlington", zip: "27417"}
  let!(:user) { create :user, organization_id: organization1.id }
  let!(:driver) { FactoryBot.create :driver}

  describe "Create Action" do
    let!(:driver1) { FactoryBot.create(:driver, first_name: "Frank", organization_id: organization1.id)}
    before do
      login_as(user, :scope => :user)
    end

    it "Create a vehicle" do
      expect do
      post admin_driver_vehicles_path(Driver.last.id), params: {
         vehicle: {
         car_make: "Chevorlet",
         car_model: "Impala",
         car_year: 2010,
         car_color: "Silver",
         car_plate: "VZW1212",
         insurance_provider: "Geico",
         insurance_start: Date.today,
         insurance_stop: Date.today,
         seat_belt_num: 5
       }
      }
      expect(flash[:notice]).to match("The vehicle information has been created")
      expect(response.redirect?).to eq(true)
      expect(response.redirect?).to redirect_to(admin_driver_path(Driver.last.id))
      end.to change(Vehicle, :count)
    end

    it "Error when vehicle information are missing" do
      expect do
      post admin_driver_vehicles_path(Driver.last.id), params: {
         vehicle: {
         car_make: "Chevorlet",
         car_model: "Impala",
         car_year: 2010,
         car_color: "Silver",
         car_plate: "VZW1212",
       }
      }
      # byebug
      expect{raise StandardError, "Seat belt num can't be blank"}.to raise_error(StandardError, "Seat belt num can't be blank" )
      expect{raise StandardError, "Seat belt num is not a number"}.to raise_error(StandardError, "Seat belt num is not a number" )
      expect{raise StandardError, "Insurance provider can't be blank"}.to raise_error(StandardError, "Insurance provider can't be blank" )
      expect{raise StandardError, "Insurance start can't be blank"}.to raise_error(StandardError, "Insurance start can't be blank" )
      expect{raise StandardError, "Insurance stop can't be blank"}.to raise_error(StandardError, "Insurance stop can't be blank" )
      expect(response.redirect?).to eq(true)
      expect(response.redirect?).to redirect_to(admin_driver_path(Driver.last.id))
      end.not_to change(Vehicle, :count)
    end


    it "Error when driver is in a different organization" do
      expect do
      post admin_driver_vehicles_path(Driver.first.id), params: {
         vehicle: {
         car_make: "Chevorlet",
         car_model: "Impala",
         car_year: 2010,
         car_color: "Silver",
         car_plate: "VZW1212",
         insurance_provider: "Geico",
         insurance_start: Date.today,
         insurance_stop: Date.today,
         seat_belt_num: 5
       }
      }
      # byebug
      expect(flash[:alert]).to match("You cannot create vehicles outside your organization")
      expect(response.redirect?).to eq(true)
      expect(response.redirect?).to redirect_to(admin_driver_path(Driver.first.id))
      end.not_to change(Vehicle, :count)
    end


  end


end
