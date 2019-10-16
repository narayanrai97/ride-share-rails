class DriversController < ApplicationController

  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  layout "administration"

  def new
    @driver = Driver.new
  end

  def show
    @driver = Driver.find(params[:id])
    authorize @driver
    @vehicles = @driver.vehicles
    @locations = @driver.locations
    @schedules = @driver.schedule_windows

    @agenda = Hash.new{ |h,k| h[k] = []}
    events = @driver.events(params[:query_start_date] ||= DateTime.now, params[:query_end_date] ||= (DateTime.now + 3.months)).sort_by { |event| event[:startTime] }
    events.each do |event|
      @agenda[Date.parse(event[:startTime].to_s).beginning_of_week] << event
    end
  end

  def index
    if params[:application_state]== "pending"
      @drivers = current_user.organization.drivers.active.pending.order(last_name: :desc)
    elsif params[:application_state]== "accepted"
      @drivers = current_user.organization.drivers.active.accepted.order(last_name: :desc)
    elsif params[:application_state]== "rejected"
      @drivers = current_user.organization.drivers.active.rejected.order(last_name: :desc)
    else
      @drivers = current_user.organization.drivers.order(last_name: :desc)
    end
    @drivers = Kaminari.paginate_array(@drivers).page(params[:page]).per(10)
  end

  def ascending_sort
    @drivers = current_user.organization.drivers.order(:last_name)
    @drivers = Kaminari.paginate_array(@drivers).page(params[:page]).per(10)
  end

  def create
    @driver = Driver.new(driver_params)
    generated_password = Devise.friendly_token.first(8)
    @driver.password = generated_password
    @driver.password_confirmation = generated_password
    @driver.organization_id = current_user.organization_id

    if @driver.save
      flash.notice = "Driver created."
      redirect_to @driver
    else
      flash[:error] = @driver.errors.full_messages
      render 'new'
    end
  end

  def edit
    @driver = Driver.find(params[:id])
    authorize @driver
  end

  def update
    @driver = Driver.find(params[:id])
    authorize @driver

    if @driver.update(driver_params)
      flash.notice = "The driver information has been updated."
      redirect_to @driver
    else
      render 'edit'
    end
  end

  #Method to Accept application
   def accept
    @driver = Driver.find(params[:driver_id])
    authorize @driver
    @driver.update_attribute(:application_state, "accepted")
    flash.notice = "The driver application has been accepted."
    redirect_to request.referrer || @driver
   end

  #Method to Reject application
  def reject
    @driver = Driver.find(params[:driver_id])
    authorize @driver
    @driver.update_attribute(:application_state, "rejected")
    flash.alert = "The driver application has been rejected."
    redirect_to @driver
  end

  #change background_check to true
  def pass
    @driver = Driver.find(params[:driver_id])
    authorize @driver
    @driver.update_attribute(:background_check, true)
    flash.notice = "The driver passed."
    redirect_to @driver
  end

  #change background_check to false
  def fail
    @driver = Driver.find(params[:driver_id])
    authorize @driver
    @driver.update_attribute(:background_check, false)
    flash.alert = "The driver failed."
    redirect_to @driver
  end

  def activation
    @driver = Driver.find(params[:driver_id])
    authorize @driver
    was_active = @driver.is_active
    @driver.toggle(:is_active).save

    if was_active == true
      flash.alert = "Driver deactivated."
    else #was_active == false
      flash.notice = "Driver reactivated."
    end
    redirect_to request.referrer || drivers_path
  end

  private
  def driver_params
    params.require(:driver).permit(:first_name, :last_name, :phone, :email, :address, :car_make, :car_model, :car_color)
  end

  def user_not_authorized
    flash.notice = "You are not authorized to view this information"
    redirect_to drivers_path
  end

end
