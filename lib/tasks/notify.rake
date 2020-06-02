namespace :db do
  namespace :seed do
    desc "Create Sample Data for Mail Test"
    task :mailtest => :environment do
      org_mailtest = Organization.create(name: "Mail Test", street: "100 Miami Blvd", city: "Durham", state: "North Carolina", zip: "27709", send_notifications: true)
      driver1 = Driver.create(organization_id: org_mailtest.id, first_name: "Driver", last_name: "One", phone: "4086948508", email: "one@none.none", password: "Pa$$word20", password_confirmation: "Pa$$word20",
        background_check: true, application_state: "accepted")
      driver2 = Driver.create(organization_id: org_mailtest.id, first_name: "Driver", last_name: "Two", phone: "4362484055", email: "two@none.none", password: "Pa$$word20", password_confirmation: "Pa$$word20",
        background_check: true, application_state: "accepted")
      driver3 = Driver.create(organization_id: org_mailtest.id, first_name: "Driver", last_name: "Three", phone: "9298694850", email: "three@none.none", password: "Pa$$word20", password_confirmation: "Pa$$word20",
        background_check: true, application_state: "accepted")
      driver4 = Driver.create(organization_id: org_mailtest.id, first_name: "John", last_name: "Four", phone: "4029348508", email: "jmcgarve@bellsouth.net", password: "Pa$$word20", password_confirmation: "Pa$$word20",
        background_check: true, application_state: "accepted")
      driver5 = Driver.create(organization_id: org_mailtest.id, first_name: "Narayan", last_name: "Five", phone: "4029348508", email: "narayanrai97@yahoo.com", password: "Pa$$word20", password_confirmation: "Pa$$word20",
        background_check: true, application_state: "accepted")
      rider1 = Rider.create(organization_id: org_mailtest.id, first_name: "Rider", last_name: "One" , phone: "9293842930", email: "r.one@none.none", password: "Pa$$word20", password_confirmation: "Pa$$word20")
      rider2 = Rider.create(organization_id: org_mailtest.id, first_name: "Rider", last_name: "Two" , phone: "3292842339",  email: "r.two@none.none", password: "Pa$$word20", password_confirmation: "Pa$$word20")
      rider3 = Rider.create(organization_id: org_mailtest.id, first_name: "Rider", last_name: "Three" , phone: "5293454293",  email: "r.three@none.none", password: "Pa$$word20", password_confirmation: "Pa$$word20")
      rider4 = Rider.create(organization_id: org_mailtest.id, first_name: "Rider", last_name: "Four" , phone: "9223842200",  email: "r.four@none.none", password: "Pa$$word20", password_confirmation: "Pa$$word20")
      loc1 = Location.new(street: "507 E Knox", city: "Durham", state: "NC", zip: "27705").save_or_touch
      loc2 = Location.new(street: "410 Liberty Street", city: "Durham", state: "NC", zip: "27705").save_or_touch
      loc3 = Location.new(street: "1824 Constitution Ct", city: "Durham", state: "NC", zip: "27705").save_or_touch
      loc4 = Location.new(street: "2200 Anderson", city: "Durham", state: "NC", zip: "27705").save_or_touch
      loc5 = Location.new(street: "923 Oregon", city: "Durham", state: "NC", zip: "27709").save_or_touch
      loc6 = Location.new(street: "2938 Rigsbee Road", city: "Durham", state: "NC", zip: "27703").save_or_touch
      loc7 = Location.new(street: "394 Alexander", city: "Durham", state: "NC", zip: "27705").save_or_touch
      loc8 = Location.new(street: "130 Pacific Ave", city: "Durham", state: "NC", zip: "27704").save_or_touch
      loc9 = Location.new(street: "394 Broadway Ave", city: "Durham", state: "NC", zip: "27705").save_or_touch
      loc10 = Location.new(street: "293 Erwin", city: "Durham", state: "NC", zip: "27705").save_or_touch
      Ride.create(organization_id: org_mailtest.id, rider_id: rider1.id , pick_up_time: DateTime.now + 5.days , start_location_id: loc5.id , end_location_id: loc10.id , reason: "Interview", status: "approved")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider2.id , pick_up_time: DateTime.now + 5.days ,   start_location_id: loc6.id , end_location_id: loc10.id , reason: "Doctor's appointment", status: "approved")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider3.id , pick_up_time: DateTime.now + 5.days ,  start_location_id: loc7.id , end_location_id: loc10.id , reason: "Haircut", status: "approved")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider4.id , pick_up_time: DateTime.now + 5.days , start_location_id: loc8.id , end_location_id: loc10.id , reason: "Teacher Conference", status: "approved")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider1.id , pick_up_time: DateTime.now + 5.days , start_location_id: loc5.id , end_location_id: loc10.id , reason: "Interview", status: "approved")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider2.id , pick_up_time: DateTime.now + 5.days ,   start_location_id: loc6.id , end_location_id: loc10.id , reason: "Doctor's appointment", status: "approved")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider3.id , pick_up_time: DateTime.now + 5.days ,  start_location_id: loc7.id , end_location_id: loc10.id , reason: "Haircut", status: "approved")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider4.id , pick_up_time: DateTime.now + 5.days , start_location_id: loc8.id , end_location_id: loc10.id , reason: "Teacher Conference", status: "approved")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider1.id , pick_up_time: DateTime.now + 5.days , start_location_id: loc5.id , end_location_id: loc10.id, reason: "Interview", status: "approved")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider2.id , pick_up_time: DateTime.now + 5.days ,   start_location_id: loc6.id , end_location_id: loc10.id , reason: "Doctor's appointment", status: "approved")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider3.id, driver_id: driver4.id , pick_up_time: DateTime.now + 1.day ,  start_location_id: loc7.id , end_location_id: loc10.id , reason: "Haircut", status: "scheduled")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider4.id, driver_id: driver4.id , pick_up_time: DateTime.now + 5.days , start_location_id: loc8.id , end_location_id: loc10.id , reason: "Teacher Conference", status: "scheduled")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider1.id, driver_id: driver5.id , pick_up_time: DateTime.now + 1.day , start_location_id: loc5.id , end_location_id: loc10.id, reason: "Interview", status: "scheduled")
      Ride.create(organization_id: org_mailtest.id, rider_id: rider2.id, driver_id: driver5.id , pick_up_time: DateTime.now + 5.days ,   start_location_id: loc6.id , end_location_id: loc10.id , reason: "Doctor's appointment", status: "scheduled")
    end
  end
  namespace :clean do
    desc "Remove Sample Data for Mail Test"
    task :mailtest => :environment do
      org_mailtest=Organization.find_by(name: "Mail Test")
      if !org_mailtest.nil?
        Ride.where(organization_id: org_mailtest.id).delete_all
        Rider.where(organization_id: org_mailtest.id).delete_all
        Driver.where(organization_id: org_mailtest.id).delete_all
        org_mailtest.destroy
      end
    end
  end
end
namespace :crsn do
  desc "Send email to drivers about upcoming rides"
  task :sendmail => :environment do
    send_email(DateTime.now.wday == 5)
  end
  desc "Testing task: send friday email regardless of day"
  task :sendmail_test => :environment do
    send_email(true)
  end
end
def send_email(weekly)
  orgs = Organization.where(send_notifications: true)
  orgs.each do |org|
    if weekly
      avail_rides = Ride.where(organization_id: org.id, status: "approved",
        pick_up_time: DateTime.now..(DateTime.now + 10.days)).order(pick_up_time: :asc).limit(15)
    else
      avail_rides = []
    end
    drivers = Driver.where(organization_id: org.id, is_active: true,
      background_check: true, application_state: "accepted")
    drivers.each do |driver|
      tomorrow_rides = Ride.where(status: "scheduled", driver_id: driver.id,
        pick_up_time: (DateTime.now  + 7.hours)..(DateTime.now + 31.hours))
      if weekly
        week_rides = Ride.where(status: "scheduled", driver_id: driver.id,
          pick_up_time: (DateTime.now  + 31.hours)..(DateTime.now + 31.hours + 6.days))
      else
        week_rides = []
      end
      if (avail_rides.any? || tomorrow_rides.any? || week_rides.any?)
        Rails.logger.info("Sending email to #{driver.email} in #{org.name} about rides:
          #{avail_rides.length} #{tomorrow_rides.length} #{week_rides.length}")
        driver_mail = driver.email.split("@")
        if (driver_mail[1] != "none.none")
          DriverMailer.driver_notification(driver,org,avail_rides, tomorrow_rides, week_rides).deliver
        end
      end
    end
  end
end
