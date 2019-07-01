
module Api
  module V1
    class ScheduleWindows < Grape::API
      include Api::V1::Defaults

      helpers EventHelpers
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
        optional :start, type: Time, desc: "Start date for schedule"
        optional :end, type: Time, desc: "End date for schedule"
      end
      get "availabilities", root: :schedule_windows do
        driver = current_driver
        schedules = ScheduleWindow.where(driver_id: driver.id)
        all_events = []
        start_time = DateTime.now
        end_time = DateTime.now+3.months
        create_all_events(schedules, start_time, end_time, all_events)
        render json: all_events
      end


      desc "Get a specific schedule window for a driver"
      params do
        requires :id, type: String, desc: "ID of the event"
      end
      get "availabilities/window/:id", root: :schedule_windows do
        schedule = ScheduleWindow.where(id: permitted_params[:id])
        all_events = []
        create_all_events(schedule, Date.today, Date.today+1.year, all_events)
        if params[:is_recurring] == false
          return { seccuss:true}
        end
        render json: all_events
      end


      desc "Create an schedule window for a driver"
      params do
        requires :start_date, type: String, desc: "Start date and time of when availability would begin recurring"
        requires :end_date, type: String, desc: "End date and time of when availability would end recurring"
        requires :start_time, type: String, desc: "End date and time of availability"
        requires :start_time, type: String, desc: "Start date and time of availability "
        requires :is_recurring, type: Boolean, desc: "Boolean if availability is recurring or not"
        requires :location_id, type: String, desc: "ID of location"
      end
      post "availabilities" do
        driver = current_driver
        schedule_window = ScheduleWindow.create(driver_id: driver.id, start_date: params[:start_date], end_date: params[:end_date], start_time: params[:start_time],end_time: params[:end_time], location_id: params[:location_id], is_recurring: params[:is_recurring])
        if params[:is_recurring] == true
          RecurringPattern.create(schedule_window_id: schedule_window.id, day_of_week: schedule_window.start_time.wday)
        end
        render schedule_window
      end


      desc "Update an schedule window for a driver"
      params do
        requires :id, type: String, desc: "ID of avaliablity"
      end
      put "availabilities/:id" do
        driver = current_driver
        schedule_window = ScheduleWindow.where(id: params[:id]).where(driver_id: driver.id).first
        schedule_window.update(driver_id: driver.id, start_date: params[:start_date], end_date: params[:end_date], start_time: params[:start_time],end_time: params[:end_time], location_id: params[:location_id], is_recurring: params[:is_recurring])
        pattern = RecurringPattern.where(schedule_window_id: schedule_window.id).first
        if pattern != nil
          pattern.destroy
        end
        if schedule_window.is_recurring == true
          RecurringPattern.create(schedule_window_id: schedule_window.id, day_of_week: schedule_window.start_time.wday)
        end
        render schedule_window
      end


      desc "Delete an avaliability"
      params do
        requires :id, type: String, desc: "ID of avaliablity"
      end
      delete "availabilities/:id" do
        driver = current_driver
        schedule_window = ScheduleWindow.where(id: params[:id]).where(driver_id: driver.id).first
        if schedule_window.is_recurring
          pattern = RecurringPattern.find_by(schedule_window_id: schedule_window.id)
          pattern.destroy
        end
        if schedule_window.destroy != nil
          return { sucess:true }
        end
      end
    end
  end
end
