 module Api
  module V1
    class Rides < Grape::API
      include Api::V1::Defaults

      helpers SessionHelpers
      helpers RideHelpers

      before do
        error!('Unauthorized', 401) unless require_login! && validate_current_driver!
      end

      desc "Return all rides"
      params do
        optional :start, type: DateTime, desc: "Start date for rides"
        optional :end, type: DateTime, desc: "End date for rides"
        optional :status, type: Array[String], except_values: ['pending'], desc: "String of status wanted"
        optional :driver_specific, type: Boolean, desc: "Boolean if rides are driver specific"
        #Missing functionality for radius feature currently
        optional :radius, type: Boolean, desc: "Boolean if rides are within radius"
        optional :location_id, type: Integer, desc: "location to use for radius"
      end
      get "rides", root: :rides do
        status = ["scheduled", "picking-up", "dropping-off", "waiting", "return-picking-up", "return-dropping-off", "completed", "canceled"]
        approved_rides = Ride.where(organization_id: current_driver.organization_id, status: "approved")
        drivers_rides = Ride.where(organization_id: current_driver.organization_id, status: status, driver_id: current_driver.id)
        rides = approved_rides.or(drivers_rides).order(:pick_up_time)

        start_time = params[:start]
        end_time = params[:end]

        if start_time.present? and end_time.present?
          rides = rides.where("pick_up_time >= ?", start_time).where("pick_up_time <= ?", end_time)
          if rides.length == 0
            status 404
            return ""
          end
        end

        status = params[:status]
        # status = Array["pending", "scheduled"]
        if status.present?
          if status == ["approved"]
            rides = rides.where(organization_id: current_driver.organization_id, status: status).order(:pick_up_time)
          else
            rides = rides.where(status: status, driver_id: current_driver.id).order(:pick_up_time)
          end

          if rides.length == 0
            status 404
            return ""
          end
        end


        if params[:driver_specific] == true
          rides = rides.where(driver_id: current_driver.id).order(:pick_up_time)
          if rides.length == 0
            status 404
            return ""
          end
        end

        # if params[:radius] == true
        #   rides.each do |ride|
        #     if check_radius(ride)
        #   end
        # end
        if params[:location_id] != nil
          begin
            location = Location.find(params[:location_id])
          rescue ActiveRecord::RecordNotFound => e
            location = nil
          end
          if location != nil
            if location.latitude != nil && location.longitude != nil
              rides_near = rides.select {|ride| ride.is_near?([location.latitude, location.longitude], current_driver.radius ) }
              if rides_near.length > 0
                status 200
                return rides_near
              else
                status 404
                return ""
              end
            else
              status 400
              return "bad requests"
            end
          else
            status 400
            return "bad requested"
          end
        end

        status 200
        return rides
      end

      # Driver seeing only the rides that they own for or have an 'approved' status
      desc "Return a ride with given ID"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      get "rides/:ride_id", root: :ride do
        ride = Ride.find(permitted_params[:ride_id])
        if (ride.driver_id == nil && ride.status == "approved") || ride.driver_id == current_driver.id
          status 201
          render ride
        else
          status 401
          render "Not Authorized"
        end
      end

      # Driver Acceting only an approved ride
      desc "Accept a ride"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/accept" do
        ride = Ride.find(permitted_params[:ride_id])
        if ride.driver_id.nil? && ride.status == "approved"
          ride.update(driver_id: current_driver.id, status: "scheduled")
          status 201
          render ride
        else
          status 401
          return "Not Authorized"
        end
      end


      # Driver picking up riders only with scheduled rides
      desc "Picking up a rider"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/picking-up" do
        ride = Ride.find(permitted_params[:ride_id])
        if ride.status == "scheduled" && ride.driver_id == current_driver.id
          ride.update_attribute(:status, "picking-up")
          status 201
          render ride
        else
          status 401
          render "Not Authorized"
        end
      end

      # Driver dropping off riders only with picking-up ride status
      desc "Dropping off a rider"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/dropping-off" do
        ride = Ride.find(permitted_params[:ride_id])
        if ride.status == "picking-up" && ride.driver_id == current_driver.id
          ride.update_attribute(:status, "dropping-off")
          status 201
          render ride
        else
          status 401
          render "Not Authorized"
        end
      end

      # Driver waiting a rider after dropping-off
      desc "Waiting a rider after dropping off"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/waiting" do
        ride = Ride.find(permitted_params[:ride_id])
        if ride.status == "dropping-off" && ride.driver_id == current_driver.id
          ride.update_attribute(:status, "waiting")
          status 201
          render ride
        else
          status 401
          render "Not Authorized"
        end
      end

      # Picking up a rider after appointment
      desc "Return picking-up after appointment"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/return-picking-up" do
        ride = Ride.find(permitted_params[:ride_id])
        if ride.status == "waiting" && ride.driver_id == current_driver.id
          ride.update_attribute(:status, "return-picking-up")
          status 201
          render ride
        else
          status 401
          render "Not Authorized"
        end
      end

      # Dropping-off a rider after appointment
      desc "Return dropping-off after appointment"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/return-dropping-off" do
        ride = Ride.find(permitted_params[:ride_id])
        if ride.status == "return-picking-up" && ride.driver_id == current_driver.id
          ride.update_attribute(:status, "return-dropping-off")
          status 201
          render ride
        else
          status 401
          render "Not Authorized"
        end
      end

      # Driver completing a ride for a rider
      desc "Complete a ride"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/complete" do
        ride = Ride.find(permitted_params[:ride_id])
        if ["dropping-off", "return-dropping-off"].include?(ride.status) && ride.driver_id == current_driver.id
          ride.update_attributes(status: "completed", completed_at: Time.now)
          status 201
          render ride
        else
          status 401
          render "Not Authorized"
        end
      end


      # Driver cancelling a ride with 'scheduled' status(but it should put ride back to 'approved' status
      # because other drivers should be able to accept the ride if they want)
      desc "Cancel a ride"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/cancel" do
        ride = Ride.find(permitted_params[:ride_id])
        if ride.status == "scheduled" && ride.driver_id == current_driver.id # && ride.pick_up_time >= Date.today + 1.week
          ride.update(driver_id: nil, status: "approved")
          status 201
          render ride
        else
          status 401
          render "Not Authorized"
        end
      end
    end
  end
end
