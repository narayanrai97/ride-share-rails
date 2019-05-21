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
          optional :start, type: String, desc: "Start date for rides"
          optional :end, type: String, desc: "End date for rides"
          optional :status, type: Array[String], desc: "String of status wanted"
          optional :driver_specific, type: Boolean, desc: "Boolean if rides are driver specific"
          optional :radius, type: Boolean, desc: "Boolean if rides are within radius"
        end
          get "rides", root: :rides do
            driver = current_driver

            start_time = params[:start]
            end_time = params[:end]

            # if start_time == nil
            #   start_time = DateTime.now-6.months
            # end
            # if end_time == nil
            #   end_time = start_time + 6.months
            # end

            if start_time != nil and end_time != nil
              rides = Ride.where(organization_id: driver.organization_id).where("pick_up_time >= ?", start_time).where("pick_up_time <= ?", end_time)
            else
              rides = Ride.where(organization_id: driver.organization_id)
            end


            status = params[:status]
            # status = Array["pending", "matched"]

            if status != nil
              rides = rides.where(status: status)
            end
            if params[:driver_specific] == true
              rides = rides.where(driver_id: driver.id)
            else
              rides = rides.where(driver_id: nil)
            end

            # if params[:radius] == true
            #   rides.each do |ride|
            #     if check_radius(ride)
            #   end
            # end


            return rides

          end



          desc "Return a ride with given ID"
          params do
            requires :id, type: String, desc: "ID of the
                ride"
          end
          get "rides/:id", root: :ride do
            Ride.find(permitted_params[:id])
          end


        desc "Accept a ride"
        params do
          requires :ride_id, type: String, desc: "ID of the ride"
        end
        post "rides/:ride_id/accept" do
          driver = current_driver
          ride = Ride.find(permitted_params[:ride_id])
          ride.update(driver_id: driver.id, status: "scheduled")
          return Ride.find(permitted_params[:ride_id])
        end


        desc "Complete a ride"
        params do
          requires :ride_id, type: String, desc: "ID of the ride"
        end
        post "rides/:ride_id/complete" do
          ride = Ride.find(permitted_params[:ride_id])
          ride.update(status: "completed")
          Ride.find(permitted_params[:ride_id])
        end

      desc "Cancel a ride"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/cancel" do
        ride = Ride.find(permitted_params[:ride_id])
        ride.update(status: "canceled")
        Ride.find(permitted_params[:ride_id])
      end


      desc "picking up rider"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/picking-up" do
        ride = Ride.find(permitted_params[:ride_id])
        ride.update(status: "picking-up")
        Ride.find(permitted_params[:ride_id])
      end

      desc "dropping off driver"
      params do
        requires :ride_id, type: String, desc: "ID of the ride"
      end
      post "rides/:ride_id/dropping-off" do
        ride = Ride.find(permitted_params[:ride_id])
        ride.update(status: "dropping-off")
        Ride.find(permitted_params[:ride_id])
      end


    end
  end
end
