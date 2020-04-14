class DriverMailer < ApplicationMailer
  default from: "noreply@ctd-crsn.org"

  def signup_confirmation(driver)
    @driver = driver

    mail to: driver.email, subject: "Sign up confirmation"
  end
end
