module Api
  module V1
    class Riders < Grape::API
      include Api::V1::Defaults

        desc "Return all riders"
        get "riders", root: :riders do
          render Rider.all
        end


      desc "Return a rider with a given ID"
      params do
        requires :id, type: String, desc: "ID of the rider"
      end
      get "rider/:id", root: :rider do
        rider = Rider.find(permitted_params[:id])
        location_ids = LocationRelationship.where(driver_id: permitted_params[:id])
        locations = []
        location_ids.each do |id|
          locations.push(Location.where(id: id))
        end
        render json: {"rider": rider, "locations": locations}
      end

    end
  end
end