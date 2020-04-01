class Admin::ScheduleWindowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_driver

  def new
    @schedule_window = @driver.schedule_windows.new
  end

  def create
    @schedule_window = @driver.schedule_windows.new(schedule_window_params)
    if @schedule_window.save
        pattern = RecurringPattern.find_by(schedule_window_id: @schedule_window.id)
        if pattern != nil
            pattern.destroy
        end
        if @schedule_window.is_recurring?
            RecurringPattern.create(schedule_window_id: @schedule_window.id, day_of_week: @schedule_window.start_time.wday)
        end
         flash.notice = "Agenda created."
         redirect_to admin_driver_path(@driver)
    else
      render 'new'
    end
  end

  def show
    @schedule_window = @driver.schedule_windows.find(params[:id])
  end



  private
    def schedule_window_params
      params.require(:schedule_window).permit(:start_date, :end_date, :start_time, :end_time, :is_recurring, :location_id)
    end

    def set_driver
      @driver = Driver.find(params[:driver_id])
    end
end
