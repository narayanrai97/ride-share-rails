module Api
  module V1
    class Locations < Grape::API
      include Api::V1::Defaults

      helpers SessionHelpers

      before do
        error!('Unauthorized', 401) unless require_login!
      end

      #
      # desc "Return all locations"
      #   get "locations/all", root: :locations do
      #     Location.all
      #   end

      #Returns a single location based off the ID
      #Lets driver look up resources that do no belong to themss
      desc "Return a location with a given ID"
      params do
        requires :id, type: String, desc: "ID of the location"
      end
      get "locations/:id", root: :location do
        render Location.find(permitted_params[:id])
      end


      #Returns all locations of the current driver
      desc "Return all locations for a given driver"
      params do
      end
      get "locations" do
        driver = current_driver
        location_ids = LocationRelationship.where(driver_id: driver.id).ids
        locations = Location.where(id: location_ids)
        render locations
      end


      #Create a location for the current driver
      #Needs address information to create
      desc "Create a new location from a driver"
      params do
        requires :location, type: Hash do
          requires :street , type:String
          requires :city, type:String
          requires :state, type: String
          requires :zip, type: String
        end
      end
      post "locations" do
        driver = current_driver
        location = Location.new
        location.attributes= (params[:location])
        if location.save
          LocationRelationship.create(location_id: location.id, driver_id: driver.id)
          render location
        end
      end

      desc "Delete an association between a driver and a location"
      params do
        requires :id, type: String, desc: "ID of location"
      end
      delete 'locations/:id' do
        driver = current_driver
        location = Location.find(permitted_params[:id])
        if location != nil
          LocationRelationship.find_by(location_id: permitted_params[:id], driver_id: driver.id).destroy
          if LocationRelationship.where(location: permitted_params[:id]).count == 0
            location.destroy
          end
          return { sucess:true }
        end
      end


      desc "put a location from a driver"
      params do
        requires :id, type: String, desc: "ID of location"
      end
      put "locations/:id" do
        driver = current_driver
        old_location = Location.find(permitted_params[:id])
        if LocationRelationship.where(location_id: permitted_params[:id]).count > 1
          new_location = Location.create(street: params[:street], city: params[:city], state: params[:state], zip: params[:zip])
          LocationRelationship.create(location_id: new_location.id, driver_id: driver.id)
          # LocationRelationship.find_by(location_id: permitted_params[:id], driver_id: driver)
        else
          old_location.update(street: params[:street], city: params[:city], state: params[:state], zip: params[:zip])
        end
          return new_location
      end


    end
  end
end
