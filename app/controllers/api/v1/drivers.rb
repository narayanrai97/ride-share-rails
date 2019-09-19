module Api
  module V1
    class Drivers < Grape::API
      include Api::V1::Defaults

      helpers SessionHelpers

      #Method to Create a Driver using api calls
      desc "Create a Driver"
      params do
        requires :driver, type: Hash do
          requires :email , type:String
          requires :password, type:String
          requires :first_name, type: String
          requires :last_name, type: String
          requires :phone, type: String
          requires :organization_id, type: Integer
          requires :is_active , type: Boolean
          optional :radius, type: Integer
        end
      end
      post "drivers" do
        driver = Driver.new
        driver.attributes= (params[:driver])
        if driver.save
          status 201
          render driver
        #Return bad request error code and error
        else
          status 400
          render driver.errors.message
        end
      end



      desc "Return a driver with a given id"
      params do
        # requires :id, type: String, desc: "ID of driver"
      end
      get "drivers", root: :driver do
        driver = current_driver
        if driver.nil?
          status 400
          return ""
        else
          location_ids = LocationRelationship.where(driver_id: current_driver.id)
          locations = []
          location_ids.each do |id|
            locations.push(Location.where(id: id))
          end
        end
        status 200
        render json: {"driver": driver, "location": locations}
      end


      desc "Update a driver with a given id"
      params do
        requires :driver, type: Hash do
          optional  :email , type:String
          optional :password, type:String
          optional :first_name, type: String
          optional :last_name, type: String
          optional :phone, type: String
          optional :is_active , type: Boolean
          optional :radius, type: Integer
        end
      end
      put "drivers" do
        driver = current_driver
      if driver.nil?
          status 400 
          return "yes"
      else 
         driver.attributes= (params[:driver])
         if driver.save
           status 200
           render json: { "driver": driver }
         else
           status 400
           render driver.errors.messages
          end
        end
      end


      desc "Delete a driver with a given id"
      params do
      end
      delete "drivers" do
        driver = current_driver
        if driver.nil?
          status 400
          return "yes"
        else 
           if driver.destroy != nil
            status 200
            return { success: true }
           else
            status 400 
            return ""
          end
        end
      end
    end
  end
end
