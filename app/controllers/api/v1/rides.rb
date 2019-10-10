module Api
  module V1
    class Rides < Grape::API
      include Api::V1::Defaults

      helpers SessionHelpers
      helpers RideHelpers


      before do
        error!('Unauthorized', 401) unless require_login!
      end


        desc "Return all rides"
        params do
          optional :start, type: DateTime, desc: "Start date for rides"
          optional :end, type: String, desc: "End date for rides"
          optional :status, type: Array[String], desc: "String of status wanted"
          optional :driver_specific, type: Boolean, desc: "Boolean if rides are driver specific"
          #Missing functionality for radius feature currently
          optional :radius, type: Boolean, desc: "Boolean if rides are within radius"
          optional :location_id, type: Integer, desc: "location to use for radius" 
        end
          get "rides", root: :rides do
            
            driver = current_driver
            
             if driver[:is_active] == false
               return "Not Authorize"
               status 404
            end
            
            start_time = params[:start]
            end_time = params[:end]
            
            if start_time != nil and end_time != nil
              rides = Ride.where(organization_id: driver.organization_id).where("pick_up_time >= ?", start_time).where("pick_up_time <= ?", end_time)
              if rides.length == 0
                status 404
                return ""
              end
            else 
              rides = Ride.where(organization_id: driver.organization_id)
              if rides.length == 0
                status 404
                return ""
              end
            end

            status = params[:status]
            # status = Array["pending", "scheduled"]

            if status != nil
              rides = rides.where(status: status)
              if rides.length == 0
                status 404
                return ""
              end
            end
            if params[:driver_specific] == true
              rides = rides.where(driver_id: driver.id)
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
                  rides_near = rides.select {|ride| ride.is_near?([location.latitude, location.longitude],driver.radius ) }
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

          desc "Return a ride with given ID"
          params do
            requires :ride_id, type: String, desc: "ID of the
                ride"
          end
          get "rides/:ride_id", root: :ride do
            driver = current_driver
            if driver[:is_active] == false
               return "Not Authorize"
               status 404
            end
            #Only can see rides that the driver own for or have no driver
            ride = Ride.find(permitted_params[:ride_id])
            if (ride.driver_id == nil or ride.driver_id ==driver.id)
              status 201 
              render ride
            else
              status(404)
              render "Unauthorized"
            end
          end

        desc "Accept a ride"
        params do
          requires :ride_id, type: String, desc: "ID of the ride"
        end
        post "rides/:ride_id/accept" do
          driver = current_driver
          ride = Ride.find(permitted_params[:ride_id])
          if (ride.driver_id == nil or ride.driver_id == driver.id)
            if ride.update(driver_id: driver.id, status: "scheduled")
              status 201
              render ride
            end
          else
            status 401
            return "Unauthorized"
          end
        end


        desc "Complete a ride"
        params do
          requires :ride_id, type: String, desc: "ID of the ride"
        end
        post "rides/:ride_id/complete" do
          driver = current_driver
          ride = Ride.find(permitted_params[:ride_id])
          if (ride.driver_id == nil or ride.driver_id ==driver.id)
            if ride.update(driver_id: driver.id, status: "completed")
              status 201
              render ride
            end
          else
             status 401
             render "Unauthorized"
          end
        end

      desc "Cancel a ride"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/cancel" do
        driver = current_driver
        ride = Ride.find(permitted_params[:ride_id])
        if (ride.driver_id == nil or ride.driver_id ==driver.id)
          if ride.update(driver_id: driver.id, status: "canceled")
            status 201
            render ride
          end
        else
          status(404)
          render "Unauthorized"
        end
      end


      desc "picking up rider"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/picking-up" do
        driver = current_driver
        ride = Ride.find(permitted_params[:ride_id])
        if (ride.driver_id == nil or ride.driver_id ==driver.id)
          if ride.update(driver_id: driver.id, status: "picking-up")
            status 201
            render ride
          end
        else
          status(404)
          render "Unauthorized"
        end
      end

      desc "dropping off driver"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/dropping-off" do
        driver = current_driver
        ride = Ride.find(permitted_params[:ride_id])
        if (ride.driver_id == nil or ride.driver_id ==driver.id)
          if ride.update(driver_id: driver.id, status: "dropping-off")
            status 201
            render ride
          end
        else
          status(404)
          render "Unauthorized"
        end
      end
    end
  end
end
