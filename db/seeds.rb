# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



org1 = Organization.create(name: "Durham Rescue Mission", street: "100 Miami Blvd", city: "Durham", state: "North Carolina", zip: "27709")
org2 = Organization.create(name: "Urban Ministires", street: "100 Miami Blvd", city: "Durham", state: "North Carolina", zip: "27709", use_tokens: true)
User.create(email: "admin@gmail.com", password: "Pa$$word20",organization_id: org1.id)
User.create(email: "admin1@gmail.com", password: "Pa$$word20",organization_id: org2.id)



driver1 = Driver.create(organization_id: org1.id, first_name: "Teddy", last_name: "Ruby", phone: "4086948508", email: "ejr25@duke.edu", password: "Pa$$word20", password_confirmation: "Pa$$word20")
driver2 = Driver.create(organization_id: org1.id, first_name: "John", last_name: "Smith", phone: "4362484055", email: "j.smith@gmail.com", password: "Pa$$word20", password_confirmation: "Pa$$word20")
driver3 = Driver.create(organization_id: org1.id, first_name: "Katie", last_name: "Jones", phone: "9298694850", email: "katie@duke.edu", password: "Pa$$word20", password_confirmation: "Pa$$word20")
driver4 = Driver.create(organization_id: org2.id, first_name: "Sarah", last_name: "Kim", phone: "4029348508", email: "Sarah.Kim@yahoo.com", password: "Pa$$word20", password_confirmation: "Pa$$word20")

vehicle1 = Vehicle.create(driver_id: driver1.id , car_make: "Toyota", car_model: "Tacoma", car_color: "Silver", car_year: "2010", car_plate: "ZQW0PQ", seat_belt_num: "4", insurance_provider: "Geico", insurance_start: "2019-02-19", insurance_stop: "2022-02-19" )
vehicle2 = Vehicle.create(driver_id: driver2.id ,car_make: "Toyota", car_model: "Camry", car_color: "Blue", car_year: "2010", car_plate: "ZQW1PQ", seat_belt_num: "4", insurance_provider: "Geico", insurance_start: "2019-01-19", insurance_stop: "2022-01-19")
vehicle3 = Vehicle.create(driver_id: driver3.id , car_make: "Honda", car_model: "Civic", car_color: "Black", car_year: "2010", car_plate: "ZQW2PQ", seat_belt_num: "4", insurance_provider: "Geico", insurance_start: "2019-03-19", insurance_stop: "2022-03-19")
vehicle4 = Vehicle.create(driver_id: driver4.id , car_make: "Nissan", car_model: "Altima", car_color: "Silver", car_year: "2010", car_plate: "ZQW3PQ", seat_belt_num: "4", insurance_provider: "Geico", insurance_start: "2019-05-19", insurance_stop: "2022-05-19")



rider1 = Rider.create(organization_id: org1.id, first_name: "Katelyn", last_name: "Splint" , phone: "9293842930", email: "ks@duke.edu", password: "Pa$$word20", password_confirmation: "Pa$$word20")
rider2 = Rider.create(organization_id: org1.id, first_name: "James", last_name: "Cage" , phone: "3292842339",  email: "cage@gmail.com", password: "Pa$$word20", password_confirmation: "Pa$$word20")
rider3 = Rider.create(organization_id: org1.id, first_name: "Mary", last_name: "Young" , phone: "5293454293",  email: "myoung@yahoo.com", password: "Pa$$word20", password_confirmation: "Pa$$word20")
rider4 = Rider.create(organization_id: org2.id, first_name: "Jim", last_name: "Free" , phone: "9223842200",  email: "free_j@gmail.com", password: "Pa$$word20", password_confirmation: "Pa$$word20")



loc1 = Location.create(street: "507 E Knox", city: "Durham", state: "NC", zip: "27705")
loc2 = Location.create(street: "410 Liberty Street", city: "Durham", state: "NC", zip: "27705")
loc3 = Location.create(street: "1824 Constitution Ct", city: "Durham", state: "NC", zip: "27705")
loc4 = Location.create(street: "2200 Anderson", city: "Durham", state: "NC", zip: "27705")
loc5 = Location.create(street: "923 Oregon", city: "Durham", state: "NC", zip: "27709")
loc6 = Location.create(street: "2938 Rigsbee Road", city: "Durham", state: "NC", zip: "27703")
loc7 = Location.create(street: "394 Alexander", city: "Durham", state: "NC", zip: "27705")
loc8 = Location.create(street: "130 Pacific Ave", city: "Durham", state: "NC", zip: "27704")
loc9 = Location.create(street: "394 Broadway Ave", city: "Durham", state: "NC", zip: "27705")
loc10 = Location.create(street: "293 Erwin", city: "Durham", state: "NC", zip: "27705")
loc11 = Location.create(street: "123 Market Street", city: "Durham", state: "NC", zip: "27701")
loc12 = Location.create(street: "3601 Hillsborough Road" , city: "Durham", state: "NC", zip: "27705")
loc13 = Location.create(street: "2200 Erwin" , city: "Durham", state: "NC", zip: "27705")
loc14 = Location.create(street: "203 E Club Blvd" , city: "Durham", state: "NC", zip: "27704")
loc15 = Location.create(street: "2938 Main Street" , city: "Durham", state: "NC", zip: "27705")
loc16 = Location.create(street: "123 Rowan Street" , city: "Durham", state: "NC", zip: "27705")
loc17 = Location.create(street: "2303 Sandy Creek Drive" , city: "Durham", state: "NC", zip: "27705")
loc18 = Location.create(street: "30 Newton Drive" , city: "Durham", state: "NC", zip: "27707")
loc19 = Location.create(street: "101 Erwin" , city: "Durham", state: "NC", zip: "27705")










Ride.create(organization_id: org1.id, rider_id: rider1.id ,  pick_up_time: "2022-02-19 15:30:00" , start_location_id: loc5.id , end_location_id: loc12.id , reason: "Interview", status: "pending")
Ride.create(organization_id: org1.id, rider_id: rider2.id ,  pick_up_time: "2022-02-22 08:30:00" ,   start_location_id: loc6.id , end_location_id: loc14.id , reason: "Doctor's appointment", status: "pending")

Ride.create(organization_id: org1.id, rider_id: rider3.id ,  pick_up_time: "2022-02-23 12:15:00" ,  start_location_id: loc7.id , end_location_id: loc15.id , reason: "Haircut", status: "approved")
Ride.create(organization_id: org2.id, rider_id: rider4.id ,  pick_up_time: "2022-03-11 14:30:00" , start_location_id: loc8.id , end_location_id: loc13.id , reason: "Teacher Conference", status: "approved")

Ride.create(organization_id: org1.id, rider_id: rider1.id , driver_id: driver1.id , pick_up_time: "2022-02-19 15:30:00" , start_location_id: loc5.id , end_location_id: loc12.id , reason: "Interview", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider2.id , driver_id: driver2.id , pick_up_time: "2022-02-22 08:30:00" ,   start_location_id: loc6.id , end_location_id: loc14.id , reason: "Doctor's appointment", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider3.id , driver_id: driver3.id , pick_up_time: "2022-02-23 12:15:00" ,  start_location_id: loc7.id , end_location_id: loc15.id , reason: "Haircut", status: "scheduled")
Ride.create(organization_id: org2.id, rider_id: rider4.id , driver_id: driver4.id , pick_up_time: "2022-03-11 14:30:00" , start_location_id: loc8.id , end_location_id: loc13.id , reason: "Teacher Conference", status: "scheduled")


Ride.create(organization_id: org1.id, rider_id: rider1.id , driver_id: driver1.id , pick_up_time: "2022-02-19 15:30:00" , start_location_id: loc5.id , end_location_id: loc12, reason: "Interview", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider2.id , pick_up_time: "2022-02-22 08:30:00" ,   start_location_id: loc6.id , end_location_id: loc14.id , reason: "Doctor's appointment", status: "pending")
Ride.create(organization_id: org1.id, rider_id: rider3.id , pick_up_time: "2022-02-23 12:15:00" ,  start_location_id: loc7.id , end_location_id: loc15.id , reason: "Haircut", status: "pending")
Ride.create(organization_id: org2.id, rider_id: rider4.id , driver_id: driver4.id , pick_up_time: "2022-03-11 14:30:00" , start_location_id: loc8.id , end_location_id: loc13.id , reason: "Teacher Conference", status: "completed")



Ride.create(organization_id: org1.id, rider_id: rider1.id ,  pick_up_time: "2022-02-20 15:30:00" , start_location_id: loc5.id , end_location_id: loc12.id , reason: "Interview", status: "pending")
Ride.create(organization_id: org1.id, rider_id: rider2.id ,  pick_up_time: "2022-02-23 08:30:00" ,   start_location_id: loc6.id , end_location_id: loc14.id , reason: "Doctor's appointment", status: "pending")

Ride.create(organization_id: org1.id, rider_id: rider3.id ,  pick_up_time: "2022-02-24 12:15:00" ,  start_location_id: loc7.id , end_location_id: loc15.id , reason: "Haircut", status: "approved")
Ride.create(organization_id: org2.id, rider_id: rider4.id ,  pick_up_time: "2022-03-14 14:30:00" , start_location_id: loc8.id , end_location_id: loc13.id , reason: "Teacher Conference", status: "approved")

Ride.create(organization_id: org1.id, rider_id: rider1.id , driver_id: driver1.id , pick_up_time: "2022-02-20 15:30:00" , start_location_id: loc5.id , end_location_id: loc12.id , reason: "Interview", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider2.id , driver_id: driver2.id , pick_up_time: "2022-02-23 08:30:00" ,   start_location_id: loc6.id , end_location_id: loc14.id , reason: "Doctor's appointment", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider3.id , driver_id: driver3.id , pick_up_time: "2022-02-24 12:15:00" ,  start_location_id: loc7.id , end_location_id: loc15.id , reason: "Haircut", status: "scheduled")
Ride.create(organization_id: org2.id, rider_id: rider4.id , driver_id: driver4.id , pick_up_time: "2022-03-15 14:30:00" , start_location_id: loc8.id , end_location_id: loc13.id , reason: "Teacher Conference", status: "scheduled")


Ride.create(organization_id: org1.id, rider_id: rider1.id , driver_id: driver1.id , pick_up_time: "2022-02-22 15:30:00" , start_location_id: loc5.id , end_location_id: loc12.id , reason: "Interview", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider2.id , pick_up_time: "2022-02-25 08:30:00" ,   start_location_id: loc6.id , end_location_id: loc14.id , reason: "Doctor's appointment", status: "pending")
Ride.create(organization_id: org1.id, rider_id: rider3.id , pick_up_time: "2022-02-25 12:15:00" ,  start_location_id: loc7.id , end_location_id: loc15.id , reason: "Haircut", status: "pending")
Ride.create(organization_id: org2.id, rider_id: rider4.id , driver_id: driver4.id , pick_up_time: "2022-03-14 14:30:00" , start_location_id: loc8.id , end_location_id: loc13.id , reason: "Teacher Conference", status: "completed")






Token.create(rider_id: rider4.id , created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4.id , created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4.id , created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4.id , created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4.id , created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4.id , created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4.id , created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4.id , created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4.id , created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4.id , created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)






sw1 = ScheduleWindow.create(driver_id: driver1.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc1.id , is_recurring: true)
sw2 = ScheduleWindow.create(driver_id: driver1.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc1.id , is_recurring: true)
sw3a = ScheduleWindow.create(driver_id: driver1.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc2.id , is_recurring: true)
sw3b = ScheduleWindow.create(driver_id: driver1.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc2.id , is_recurring: true)
sw4 = ScheduleWindow.create(driver_id: driver1.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc3.id , is_recurring: true)

sw5 = ScheduleWindow.create(driver_id: driver2.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc4.id , is_recurring: true)
sw6 = ScheduleWindow.create(driver_id: driver2.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours,location_id: loc4.id ,  is_recurring: true)
sw7 = ScheduleWindow.create(driver_id: driver2.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc4.id , is_recurring: true)
sw8 = ScheduleWindow.create(driver_id: driver2.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc4.id , is_recurring: true)

sw9 = ScheduleWindow.create(driver_id: driver3.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc5.id , is_recurring: true)
sw10 = ScheduleWindow.create(driver_id: driver3.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours,location_id: loc5.id ,  is_recurring: true)
sw11 = ScheduleWindow.create(driver_id: driver3.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc5.id , is_recurring: true)
sw12 = ScheduleWindow.create(driver_id: driver3.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc5.id , is_recurring: true)

sw13 = ScheduleWindow.create(driver_id: driver4.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc6.id , is_recurring: true)
sw14 = ScheduleWindow.create(driver_id: driver4.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc6.id , is_recurring: true)
sw15 = ScheduleWindow.create(driver_id: driver4.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc7.id , is_recurring: true)
sw16 = ScheduleWindow.create(driver_id: driver4.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: Time.now + 28.hours, location_id: loc8.id , is_recurring: true)


sw17 = ScheduleWindow.create(driver_id: driver1.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: "2019-03-06 12:00:00", location_id: loc1.id , is_recurring: false)
sw18 = ScheduleWindow.create(driver_id: driver1.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: "2019-03-13 16:30:00", location_id: loc1.id , is_recurring: false)

sw19 = ScheduleWindow.create(driver_id: driver2.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: "2019-03-07 12:00:00", location_id: loc4.id , is_recurring: false)
sw20 = ScheduleWindow.create(driver_id: driver2.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: "2019-03-14 17:30:00", location_id: loc4.id , is_recurring: false)

sw21 = ScheduleWindow.create(driver_id: driver3.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: "2019-03-08 12:30:00", location_id: loc5.id , is_recurring: false)
sw22 = ScheduleWindow.create(driver_id: driver3.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: "2019-03-15 16:30:00", location_id: loc5.id , is_recurring: false)

sw23 = ScheduleWindow.create(driver_id: driver4.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: "2019-03-11 12:30:00", location_id: loc6.id , is_recurring: false)
sw24 = ScheduleWindow.create(driver_id: driver4.id , start_date: (Time.now + 1.day).to_date, end_date: (Time.now + 3.months).to_date, start_time: Time.now + 26.hours, end_time: "2019-03-12 18:00:00", location_id: loc7.id , is_recurring: false)




RecurringPattern.create(schedule_window_id: sw1.id , day_of_week: sw1.start_time.wday)
RecurringPattern.create(schedule_window_id: sw2.id , day_of_week: sw2.start_time.wday)
RecurringPattern.create(schedule_window_id: sw3a.id , day_of_week: sw3a.start_time.wday)
RecurringPattern.create(schedule_window_id: sw3b.id , day_of_week: sw3b.start_time.wday)
RecurringPattern.create(schedule_window_id: sw4.id , day_of_week: sw4.start_time.wday)

RecurringPattern.create(schedule_window_id: sw5.id , day_of_week: sw5.start_time.wday)
RecurringPattern.create(schedule_window_id: sw6.id , day_of_week: sw6.start_time.wday)
RecurringPattern.create(schedule_window_id: sw7.id , day_of_week: sw7.start_time.wday)
RecurringPattern.create(schedule_window_id: sw8.id , day_of_week: sw8.start_time.wday)

RecurringPattern.create(schedule_window_id: sw9.id , day_of_week: sw9.start_time.wday)
RecurringPattern.create(schedule_window_id: sw10.id , day_of_week: sw10.start_time.wday)
RecurringPattern.create(schedule_window_id: sw11.id , day_of_week: sw11.start_time.wday)
RecurringPattern.create(schedule_window_id: sw12.id , day_of_week: sw12.start_time.wday)

RecurringPattern.create(schedule_window_id: sw13.id , day_of_week: sw13.start_time.wday)
RecurringPattern.create(schedule_window_id: sw14.id , day_of_week: sw14.start_time.wday)
RecurringPattern.create(schedule_window_id: sw15.id , day_of_week: sw15.start_time.wday)
RecurringPattern.create(schedule_window_id: sw16.id , day_of_week: sw16.start_time.wday)


LocationRelationship.create(default: false, location_id: loc1.id , driver_id: driver1.id , rider_id: nil, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc2.id , driver_id: driver1.id , rider_id: nil, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc3.id , driver_id: driver1.id , rider_id: nil, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc4.id , driver_id: driver1.id , rider_id: nil, organization_id: nil)

LocationRelationship.create(default: false, location_id: loc5.id , driver_id: nil, rider_id: rider1, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc6.id , driver_id: nil, rider_id: rider2, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc7.id , driver_id: nil, rider_id: rider3, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc8.id , driver_id: nil, rider_id: rider4, organization_id: nil)

LocationRelationship.create(default: false, location_id: loc9.id , driver_id: nil, rider_id: nil, organization_id: org1.id)
LocationRelationship.create(default: false, location_id: loc10.id , driver_id: nil, rider_id: nil, organization_id: org2.id)

LocationRelationship.create(default: true, location_id: loc11.id , driver_id: driver1.id , rider_id: nil, organization_id: nil)

LocationRelationship.create(default: false, location_id: loc12.id , driver_id: nil, rider_id: nil, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc13.id , driver_id: nil, rider_id: nil, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc14.id , driver_id: nil, rider_id: nil, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc15.id , driver_id: nil, rider_id: nil, organization_id: nil)




LocationRelationship.create(default: false, location_id: loc16.id , driver_id: driver2.id , rider_id: nil, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc17.id , driver_id: driver3.id , rider_id: nil, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc18.id , driver_id: driver3.id , rider_id: nil, organization_id: nil)
LocationRelationship.create(default: true, location_id: loc19.id , driver_id: driver3.id , rider_id: nil, organization_id: nil)
LocationRelationship.create(default: false, location_id: loc10.id , driver_id: driver4.id , rider_id: nil, organization_id: nil)






# ScheduleWindowException(schedule_window_id: "1", is_canceled: true)
