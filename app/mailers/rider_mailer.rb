class RiderMailer < ApplicationMailer
  default from: "noreply@ctd-crsn.org"

  def ride_accepted_notifications(ride)
    @ride = ride
    @rider = Rider.find(ride.rider_id)
    @driver = Driver.find(ride.driver_id)

    mail to: @rider.email, subject: "Ride accepted"
  end
end
