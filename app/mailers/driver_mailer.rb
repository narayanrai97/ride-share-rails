class DriverMailer < ApplicationMailer
  default from: "noreply@ctd-crsn.org"

  def signup_confirmation(driver)
    @driver = driver

    mail to: driver.email, subject: "Sign up confirmation"
  end

  def driver_notification(driver,org,avail_rides,tomorrow_rides,week_rides)
    @driver = driver
    @org = org
    @avail_rides = avail_rides
    @tomorrow_rides = tomorrow_rides
    @week_rides = week_rides
    mail to: driver.email, subject: "Upcoming Rides For Volunteer Drivers"
  end
end
