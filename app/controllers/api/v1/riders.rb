module Api
  module V1
    class Riders < Grape::API
      include Api::V1::Defaults
      # Commented out termporarily for security reasons
      if false
        desc "Return all riders"
        get "riders", root: :riders do
          riders = Rider.all
          if riders.all.empty?
            status 404
            return ""
          else
            status 201
            render json: riders
          end
        end


        desc "Return a rider with a given ID"
        params do
          requires :id, type: String, desc: "ID of the rider"
        end
        get "riders/:id", root: :rider do
          rider = Rider.find(permitted_params[:id])
          location_ids = LocationRelationship.where(driver_id: permitted_params[:id])
          locations = []
          location_ids.each do |id|
            locations.push(Location.where(id: id))
          end
          if rider != nil
           status 201
           render json: {"rider": rider, "locations": locations}
          else
           status 404
           return ""
          end
        end
      end
    end
  end
end
