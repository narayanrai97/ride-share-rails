module Api
  module V1
    class Drivers < Grape::API
      include Api::V1::Defaults

      helpers SessionHelpers

      #Method to Create a Driver using api calls
      desc "Create a Driver"
      params do
        requires :email , type:String
        requires :password, type:String
        requires :first_name, type: String
        requires :last_name, type: String
        requires :phone, type: String
        requires :organization_id, type: Integer
      end
      post "drivers(json)" do
        driver = Driver.new({organization_id: params[:organization_id], email: params[:email],password: params[:password],first_name: params[:first_name],last_name: params[:last_name],phone: params[:phone]})
        if driver.save
          status 200
          render json: driver
        #Return bad request error code and error
        else
          status 400
          render json: driver.errors

        end
      end


      #Seperate namespace so that these require login to access
      namespace do
        before do
          error!('Unauthorized', 401) unless require_login!
        end



    #Method to create application for user, requires information for vehicle and updates state of driver to pending
        desc "Create Application from App"
        params do

          requires :car_make, type: String, desc: " Car Manufactor of Driver"
          requires :car_model, type: String, desc: " Car Model of Driver"
          requires :car_year, type: Integer, desc: " Car Year of Driver"
          requires :car_color, type: String, desc: " Car Color of driver"
          requires :car_plate, type: String, desc: " Car plate of driver"
          requires :seat_belt_num, type: Integer, desc: " Car plate of driver"
          requires :insurance_provider, type: String, desc: " Insurance Provider for driver"
          requires :insurance_start, type: Date, desc: " Insurance start date"
          requires :insurance_stop, type: Date, desc: " Insurance start date"
        end
        post "drivers/application" do
          driver = current_driver

          vehicle = Vehicle.new(driver_id: current_driver.id, car_make: params[:car_make], car_model: params[:car_model],
                          car_year: params[:car_year], car_color: params[:car_color],
                          car_plate: params[:car_plate], insurance_provider: params[:insurance_provider],
                          insurance_start: params[:insurance_start], insurance_stop: params[:insurance_stop],seat_belt_num: params[:seat_belt_num])
            driver.application_state ="pending"
            if vehicle.save
              driver.save
              render :driver => driver, vehicles: driver.vehicles
            end

        end


        #Method to get application info for logged in user, currently just the information in application
      desc "Get Application Info"
      params do
      end
      get "drivers/application" do
        driver = current_driver




          @application = {
            :email => driver.email,
            :application_state  => driver.application_state

          }


        render :driver => @application, vehicles: driver.vehicles
      end









        desc "Return a driver with a given id"
        params do
          # requires :id, type: String, desc: "ID of driver"
        end
        get "drivers", root: :driver do
          driver = current_driver
          location_ids = LocationRelationship.where(driver_id: current_driver.id)
          locations = []
          location_ids.each do |id|
            locations.push(Location.where(id: id))
          end
          return driver
          #render json: {"driver": driver, "location": locations}
        end


        desc "Update a driver with a given id"
        params do
        end
        put "drivers" do
          driver = current_driver
          driver.update(first_name: params[:first_name], last_name: params[:last_name], phone: params[:phone],
                        email: params[:email], car_make: params[:car_make], car_model: params[:car_model],
                        car_color: params[:car_color], radius: params[:radius], is_active: params[:is_active])
          return current_driver
        end


        desc "Delete a driver with a given id"
        params do
        end
        delete "drivers" do
          driver = current_driver
          if driver.destroy != nil
            return { sucess:true }
          end
        end
      end
    end
  end
end
