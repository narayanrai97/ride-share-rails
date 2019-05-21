module Api
  module V1
    class Drivers < Grape::API
      include Api::V1::Defaults

      helpers SessionHelpers


      before do
        error!('Unauthorized', 401) unless require_login!
      end



    # desc "Return all drivers"
    # get "/drivers/all", root: :driver do
    #   Driver.all
    # end



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