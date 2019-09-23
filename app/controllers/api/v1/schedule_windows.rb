
module Api
  module V1
    class ScheduleWindows < Grape::API
      include Api::V1::Defaults

      helpers SessionHelpers

      before do
        error!('Unauthorized', 401) unless require_login!
      end

      # desc "Return all schedule windows"
      # get "availabilities", root: :schedule_windows do
      #   ScheduleWindow.all
      # end


      desc "Get a full schedule for a driver"
      params do
        optional :start, type: DateTime, desc: "Start date for schedule"
        optional :end, type: DateTime, desc: "End date for schedule"
      end
      get "availabilities", root: :schedule_windows do
        start_time = params[:start_time] || DateTime.now
        end_time = params[:end_time] ||  DateTime.now+3.months
        result = current_driver.events(start_time, end_time)
        if result != nil
          status 200
        else
          status 404
        end
        render json: result
      end


      desc "Get a specific schedule window for a driver"
      params do
        requires :id, type: String, desc: "ID of the event"
        optional :start_date, DateTime, desc: "Start Date"
        optional :end_date, DateTime, desc: "End Date"
      end
      get "availabilities/window/:id", root: :schedule_windows do
        schedule = ScheduleWindow.find(permitted_params[:id])
        start_time = params[:start_date] || DateTime.now
        end_time = params[:end_date] ||  DateTime.now+3.months
        result = schedule.events(start_time, end_time)
        if result != nil
          status 200
        else
          status 404
        end
        render json: result
      end


      desc "Create an schedule window for a driver"
      params do
        optional :start_date, type: String, desc: "Start date and time of when availability would begin recurring"
        optional :end_date, type: String, desc: "End date and time of when availability would end recurring"
        requires :start_time, type: String, desc: "Start date and time of availability"
        requires :end_time, type: String, desc: "End date and time of availability "
        requires :is_recurring, type: Boolean, desc: "Boolean if availability is recurring or not"
        requires :location_id, type: String, desc: "ID of location"
      end
      post "availabilities" do
        attributes = {start_date: params[:start_date], end_date: params[:end_date], 
        start_time: params[:start_time],end_time: params[:end_time], location_id: params[:location_id], 
        is_recurring: params[:is_recurring]}
        
            schedule_window = current_driver.schedule_windows.new(attributes)
            save_return = schedule_window.save
           if (save_return)
                 pattern = RecurringPattern.find_by(schedule_window_id: schedule_window.id)
                if pattern != nil
                    pattern.destroy
                end
                if schedule_window.is_recurring?
                    RecurringPattern.create(schedule_window_id: schedule_window.id, day_of_week: schedule_window.start_time.wday)
                end
                 status 201
                 schedule_window  
           else
                 status 404
                 schedule_window.errors.messages
           end
      end


      desc "Update an schedule window for a driver"
      params do
        requires :start_date, type: String, desc: "Start date and time of when availability would begin recurring"
        requires :end_date, type: String, desc: "End date and time of when availability would end recurring"
        requires :start_time, type: String, desc: "Start date and time of availability"
        requires :end_time, type: String, desc: "End date and time of availability "
        requires :is_recurring, type: Boolean, desc: "Boolean if availability is recurring or not"
        requires :location_id, type: String, desc: "ID of location"
      end
      put "availabilities/:id" do
        attributes = {start_date: params[:start_date], end_date: params[:end_date], 
        start_time: params[:start_time],end_time: params[:end_time], location_id: params[:location_id], 
        is_recurring: params[:is_recurring]}
        
        schedule_window = current_driver.schedule_windows.find(params[:id])
        update_return = schedule_window.update(attributes)
  
        pattern = RecurringPattern.find_by(schedule_window_id: schedule_window.id)
          if pattern != nil
            pattern.destroy
          end
          if schedule_window.is_recurring?
            RecurringPattern.create(schedule_window_id: schedule_window.id, day_of_week: schedule_window.start_time.wday)
          end
          if update_return
            
            status 202
            schedule_window
          else 
            status 404
             schedule_window.errors.messages
          end
      end


      desc "Delete an avaliability"
      params do
        requires :id, type: String, desc: "ID of avaliablity"
      end
      delete "availabilities/:id" do
        schedule_window = current_driver.schedule_windows.find(params[:id])
        if schedule_window.is_recurring
          pattern = RecurringPattern.find_by(schedule_window_id: schedule_window.id)
          pattern.destroy
        end
        if schedule_window.destroy != nil
          status 200
        end
      end
    end
  end
end
