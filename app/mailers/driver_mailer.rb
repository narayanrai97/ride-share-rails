class DriverMailer < ApplicationMailer
  default from: "noreply@ctd-crsn.org"

  def signup_confirmation(driver)
    @driver = driver

    mail to: driver.email, subject: "Sign up confirmation"
  end

  def weekly_notification(driver,org,rides)
    @driver = driver
    @org = org
    @rides = rides
    mail to: driver.email, subject: "Upcoming Rides Needing Drivers"
  end
end
