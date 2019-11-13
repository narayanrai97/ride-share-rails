# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



org1 = Organization.create(name: "Durham Rescue Mission", street: "100 Miami Blvd", city: "Durham", state: "North Carolina", zip: "27709")
org2 = Organization.create(name: "Urban Ministires", street: "100 Miami Blvd", city: "Durham", state: "North Carolina", zip: "27709", use_tokens: true)
User.create(email: "admin@gmail.com", password: "password",organization_id: org1.id)
User.create(email: "admin1@gmail.com", password: "password",organization_id: org2.id)



driver1 = Driver.create(organization_id: org1.id, first_name: "Teddy", last_name: "Ruby", phone: "4086948508", email: "ejr25@duke.edu", password: "password", password_confirmation: "password")
driver2 = Driver.create(organization_id: org1.id, first_name: "John", last_name: "Smith", phone: "4362484055", email: "j.smith@gmail.com", password: "password", password_confirmation: "password")
driver3 = Driver.create(organization_id: org1.id, first_name: "Katie", last_name: "Jones", phone: "92986948508", email: "katie@duke.edu", password: "password", password_confirmation: "password")
driver4 = Driver.create(organization_id: org2.id, first_name: "Sarah", last_name: "Kim", phone: "4029348508", email: "Sarah.Kim@yahoo.com", password: "password", password_confirmation: "password")

vehicle1 = Vehicle.create(driver_id: driver1, car_make: "Toyota", car_model: "Tacoma", car_color: "Silver", car_year: "2010", car_plate: "ZQWOPQ", seat_belt_num: "4", insurance_provider: "Geico", insurance_start: "2019-02-19", insurance_stop: "2022-02-19" )
vehicle2 = Vehicle.create(driver_id: driver2,car_make: "Toyota", car_model: "Camry", car_color: "Blue", car_year: "2010", car_plate: "ZQWOPQ", seat_belt_num: "4", insurance_provider: "Geico", insurance_start: "2019-01-19", insurance_stop: "2022-01-19")
vehicle3 = Vehicle.create(driver_id: driver3, car_make: "Honda", car_model: "Civic", car_color: "Black", car_year: "2010", car_plate: "ZQWOPQ", seat_belt_num: "4", insurance_provider: "Geico", insurance_start: "2019-03-19", insurance_stop: "2022-03-19")
vehicle4 = Vehicle.create(driver_id: driver4, car_make: "Nissan", car_model: "Altima", car_color: "Silver", car_year: "2010", car_plate: "ZQWOPQ", seat_belt_num: "4", insurance_provider: "Geico", insurance_start: "2019-05-19", insurance_stop: "2022-05-19")



rider1 = Rider.create(organization_id: org1.id, first_name: "Katelyn", last_name: "Splint" , phone: "9293842930", email: "ks@duke.edu", password: "password", password_confirmation: "password")
rider2 = Rider.create(organization_id: org1.id, first_name: "James", last_name: "Cage" , phone: "3292842339",  email: "cage@gmail.com", password: "password", password_confirmation: "password")
rider3 = Rider.create(organization_id: org1.id, first_name: "Mary", last_name: "Young" , phone: "52934542930",  email: "myoung@yahoo.com", password: "password", password_confirmation: "password")
rider4 = Rider.create(organization_id: org2.id, first_name: "Jim", last_name: "Free" , phone: "9223842200",  email: "free_j@gmail.com", password: "password", password_confirmation: "password")



loc1 = Location.create(street: "507 E Knox", city: "Durham", state: "NC", zip: "27705")
loc2 = Location.create(street: "410 Liberty Street", city: "Durham", state: "NC", zip: "27705")
loc3 = Location.create(street: "1824 Constitution Ct", city: "Durham", state: "NC", zip: "27705")
loc4 = Location.create(street: "2200 Anderson", city: "Durham", state: "NC", zip: "27705")
loc5 = Location.create(street: "923 Oregon", city: "Durham", state: "NC", zip: "27709")
loc6 = Location.create(street: "2938 Rigsbee", city: "Durham", state: "NC", zip: "27708")
loc7 = Location.create(street: "394 Alexander", city: "Durham", state: "NC", zip: "277054")
loc8 = Location.create(street: "1830 Pacific Ave", city: "Durham", state: "NC", zip: "27710")
loc9 = Location.create(street: "394 Broadway Ave", city: "Durham", state: "NC", zip: "27705")
loc10 = Location.create(street: "293 Erwin", city: "Durham", state: "NC", zip: "27705")
loc11 = Location.create(street: "123 Road way", city: "Durham", state: "NC", zip: "27705")
loc12 = Location.create(street: "840 Hillsborough" , city: "Durham", state: "NC", zip: "27705")
loc13 = Location.create(street: "2200 Erwin" , city: "Durham", state: "NC", zip: "27705")
loc14 = Location.create(street: "203 Club Ave." , city: "Durham", state: "NC", zip: "27705")
loc15 = Location.create(street: "2938 Main Street" , city: "Durham", state: "NC", zip: "27705")
loc16 = Location.create(street: "123 Row Way" , city: "Durham", state: "NC", zip: "27705")
loc17 = Location.create(street: "2303 Sandy Street" , city: "Durham", state: "NC", zip: "27705")
loc18 = Location.create(street: "30 New Drive" , city: "Durham", state: "NC", zip: "27705")
loc19 = Location.create(street: "101 Erwin" , city: "Durham", state: "NC", zip: "27705")










Ride.create(organization_id: org1.id, rider_id: rider1,  pick_up_time: "2022-02-19 15:30:00" , start_location_id: loc5, end_location_id: loc12, reason: "Interview", status: "pending")
Ride.create(organization_id: org1.id, rider_id: rider2,  pick_up_time: "2022-02-22 08:30:00" ,   start_location_id: loc6, end_location_id: loc14, reason: "Doctor's appointment", status: "pending")

Ride.create(organization_id: org1.id, rider_id: rider3,  pick_up_time: "2022-02-23 12:15:00" ,  start_location_id: loc7, end_location_id: loc15, reason: "Haircut", status: "approved")
Ride.create(organization_id: org2.id, rider_id: rider4,  pick_up_time: "2022-03-11 14:30:00" , start_location_id: loc8, end_location_id: loc13, reason: "Teacher Conference", status: "approved")

Ride.create(organization_id: org1.id, rider_id: rider1, driver_id: driver1, pick_up_time: "2022-02-19 15:30:00" , start_location_id: loc5, end_location_id: loc12, reason: "Interview", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider2, driver_id: driver2, pick_up_time: "2022-02-22 08:30:00" ,   start_location_id: loc6, end_location_id: loc14, reason: "Doctor's appointment", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider3, driver_id: driver3, pick_up_time: "2022-02-23 12:15:00" ,  start_location_id: loc7, end_location_id: loc15, reason: "Haircut", status: "scheduled")
Ride.create(organization_id: org2.id, rider_id: rider4, driver_id: driver4, pick_up_time: "2022-03-11 14:30:00" , start_location_id: loc8, end_location_id: loc13, reason: "Teacher Conference", status: "scheduled")


Ride.create(organization_id: org1.id, rider_id: rider1, driver_id: driver1, pick_up_time: "2022-02-19 15:30:00" , start_location_id: loc5, end_location_id: loc12, reason: "Interview", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider2, pick_up_time: "2022-02-22 08:30:00" ,   start_location_id: loc6, end_location_id: loc14, reason: "Doctor's appointment", status: "pending")
Ride.create(organization_id: org1.id, rider_id: rider3, pick_up_time: "2022-02-23 12:15:00" ,  start_location_id: loc7, end_location_id: loc15, reason: "Haircut", status: "pending")
Ride.create(organization_id: org2.id, rider_id: rider4, driver_id: driver4, pick_up_time: "2022-03-11 14:30:00" , start_location_id: loc8, end_location_id: loc13, reason: "Teacher Conference", status: "completed")



Ride.create(organization_id: org1.id, rider_id: rider1,  pick_up_time: "2022-02-20 15:30:00" , start_location_id: loc5, end_location_id: loc12, reason: "Interview", status: "pending")
Ride.create(organization_id: org1.id, rider_id: rider2,  pick_up_time: "2022-02-23 08:30:00" ,   start_location_id: loc6, end_location_id: loc14, reason: "Doctor's appointment", status: "pending")

Ride.create(organization_id: org1.id, rider_id: rider3,  pick_up_time: "2022-02-24 12:15:00" ,  start_location_id: loc7, end_location_id: loc15, reason: "Haircut", status: "approved")
Ride.create(organization_id: org2.id, rider_id: rider4,  pick_up_time: "2022-03-14 14:30:00" , start_location_id: loc8, end_location_id: loc13, reason: "Teacher Conference", status: "approved")

Ride.create(organization_id: org1.id, rider_id: rider1, driver_id: driver1, pick_up_time: "2022-02-20 15:30:00" , start_location_id: loc5, end_location_id: loc12, reason: "Interview", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider2, driver_id: driver2, pick_up_time: "2022-02-23 08:30:00" ,   start_location_id: loc6, end_location_id: loc14, reason: "Doctor's appointment", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider3, driver_id: driver3, pick_up_time: "2022-02-24 12:15:00" ,  start_location_id: loc7, end_location_id: loc15, reason: "Haircut", status: "scheduled")
Ride.create(organization_id: org2.id, rider_id: rider4, driver_id: driver4, pick_up_time: "2022-03-15 14:30:00" , start_location_id: loc8, end_location_id: loc13, reason: "Teacher Conference", status: "scheduled")


Ride.create(organization_id: org1.id, rider_id: rider1, driver_id: driver1, pick_up_time: "2022-02-22 15:30:00" , start_location_id: loc5, end_location_id: loc12, reason: "Interview", status: "scheduled")
Ride.create(organization_id: org1.id, rider_id: rider2, pick_up_time: "2022-02-25 08:30:00" ,   start_location_id: loc6, end_location_id: loc14, reason: "Doctor's appointment", status: "pending")
Ride.create(organization_id: org1.id, rider_id: rider3, pick_up_time: "2022-02-25 12:15:00" ,  start_location_id: loc7, end_location_id: loc15, reason: "Haircut", status: "pending")
Ride.create(organization_id: org2.id, rider_id: rider4, driver_id: driver4, pick_up_time: "2022-03-14 14:30:00" , start_location_id: loc8, end_location_id: loc13, reason: "Teacher Conference", status: "completed")






Token.create(rider_id: rider1, created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider1, created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider1, created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider2, created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider2, created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider2, created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider3, created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider3, created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4, created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)
Token.create(rider_id: rider4, created_at: Time.now, expires_at: Time.now + 1.year,  used_at: nil, is_valid: true)






sw1 = ScheduleWindow.create(driver_id: driver1, start_date: "2019-3-4", end_date: "2020-3-9", start_time: "2019-03-04 10:30:00", end_time: "2019-03-04 12:30:00", location_id: loc1, is_recurring: true)
sw2 = ScheduleWindow.create(driver_id: driver1, start_date: "2019-3-5", end_date: "2020-3-10", start_time: "2019-03-05 12:30:00", end_time: "2019-03-05 16:30:00", location_id: loc1, is_recurring: true)
sw3 = ScheduleWindow.create(driver_id: driver1, start_date: "2019-3-7", end_date: "2019-3-12", start_time: "2019-03-07 09:00:00", end_time: "2019-03-07 13:00:00", location_id: loc2, is_recurring: true)
sw4 = ScheduleWindow.create(driver_id: driver1, start_date: "2019-3-8", end_date: "2020-3-13", start_time: "2019-03-08 10:30:00", end_time: "2019-03-08 10:30:00", location_id: loc3, is_recurring: true)

sw5 = ScheduleWindow.create(driver_id: driver2, start_date: "2019-3-4", end_date: "2020-3-9", start_time: "2019-03-04 10:30:00", end_time: "2019-03-04 12:30:00", location_id: loc4, is_recurring: true)
sw6 = ScheduleWindow.create(driver_id: driver2, start_date: "2019-3-4", end_date: "2020-3-9", start_time: "2019-03-04 14:30:00", end_time: "2019-03-04 16:30:00",location_id: loc4,  is_recurring: true)
sw7 = ScheduleWindow.create(driver_id: driver2, start_date: "2019-3-8", end_date: "2019-3-12", start_time: "2019-03-08 11:00:00", end_time: "2019-03-08 15:00:00", location_id: loc4, is_recurring: true)
sw8 = ScheduleWindow.create(driver_id: driver2, start_date: "2019-3-9", end_date: "2020-3-13", start_time: "2019-03-09 12:30:00", end_time: "2019-03-09 17:30:00", location_id: loc4, is_recurring: true)

sw9 = ScheduleWindow.create(driver_id: driver3, start_date: "2019-3-4", end_date: "2020-3-9", start_time: "2019-03-04 10:30:00", end_time: "2019-03-04 12:00:00", location_id: loc5, is_recurring: true)
sw10 = ScheduleWindow.create(driver_id: driver3, start_date: "2019-3-5", end_date: "2020-3-10", start_time: "2019-03-05 12:30:00", end_time: "2019-03-05 16:30:00",location_id: loc5,  is_recurring: true)
sw11 = ScheduleWindow.create(driver_id: driver3, start_date: "2019-3-6", end_date: "2019-3-12", start_time: "2019-03-06 09:00:00", end_time: "2019-03-06 12:00:00", location_id: loc5, is_recurring: true)
sw12 = ScheduleWindow.create(driver_id: driver3, start_date: "2019-3-6", end_date: "2020-3-13", start_time: "2019-03-06 14:30:00", end_time: "2019-03-06 17:30:00", location_id: loc5, is_recurring: true)

sw13 = ScheduleWindow.create(driver_id: driver4, start_date: "2019-3-9", end_date: "2020-3-9", start_time: "2019-03-09 10:00:00", end_time: "2019-03-09 12:30:00", location_id: loc6, is_recurring: true)
sw14 = ScheduleWindow.create(driver_id: driver4, start_date: "2019-3-9", end_date: "2020-3-10", start_time: "2019-03-09 14:00:00", end_time: "2019-03-09 16:30:00", location_id: loc6, is_recurring: true)
sw15 = ScheduleWindow.create(driver_id: driver4, start_date: "2019-3-10", end_date: "2019-3-12", start_time: "2019-03-10 09:00:00", end_time: "2019-03-10 12:30:00", location_id: loc7, is_recurring: true)
sw16 = ScheduleWindow.create(driver_id: driver4, start_date: "2019-3-10", end_date: "2020-3-13", start_time: "2019-03-10 14:30:00", end_time: "2019-03-10 18:00:00", location_id: loc8, is_recurring: true)


sw17 = ScheduleWindow.create(driver_id: driver1, start_date: "2019-3-6", end_date: "2020-3-6", start_time: "2019-03-06 10:30:00", end_time: "2019-03-06 12:00:00", location_id: loc1, is_recurring: false)
sw18 = ScheduleWindow.create(driver_id: driver1, start_date: "2019-3-13", end_date: "2020-3-13", start_time: "2019-03-13 12:30:00", end_time: "2019-03-13 16:30:00", location_id: loc1, is_recurring: false)

sw19 = ScheduleWindow.create(driver_id: driver2, start_date: "2019-3-7", end_date: "2019-3-7", start_time: "2019-03-07 09:00:00", end_time: "2019-03-07 12:00:00", location_id: loc4, is_recurring: false)
sw20 = ScheduleWindow.create(driver_id: driver2, start_date: "2019-3-14", end_date: "2020-3-14", start_time: "2019-03-14 14:30:00", end_time: "2019-03-14 17:30:00", location_id: loc4, is_recurring: false)

sw21 = ScheduleWindow.create(driver_id: driver3, start_date: "2019-3-8", end_date: "2020-3-8", start_time: "2019-03-08 10:00:00", end_time: "2019-03-08 12:30:00", location_id: loc5, is_recurring: false)
sw22 = ScheduleWindow.create(driver_id: driver3, start_date: "2019-3-15", end_date: "2020-3-15", start_time: "2019-03-15 14:00:00", end_time: "2019-03-15 16:30:00", location_id: loc5, is_recurring: false)

sw23 = ScheduleWindow.create(driver_id: driver4, start_date: "2019-3-11", end_date: "2019-3-11", start_time: "2019-03-11 09:00:00", end_time: "2019-03-11 12:30:00", location_id: loc6, is_recurring: false)
sw24 = ScheduleWindow.create(driver_id: driver4, start_date: "2019-3-12", end_date: "2020-3-12", start_time: "2019-03-12 14:30:00", end_time: "2019-03-12 18:00:00", location_id: loc7, is_recurring: false)




RecurringPattern.create(schedule_window_id: sw1, day_of_week: "1")
RecurringPattern.create(schedule_window_id: sw2, day_of_week: "2")
RecurringPattern.create(schedule_window_id: sw3, day_of_week: "4")
RecurringPattern.create(schedule_window_id: sw4, day_of_week: "5")

RecurringPattern.create(schedule_window_id: sw5, day_of_week: "1")
RecurringPattern.create(schedule_window_id: sw6, day_of_week: "1")
RecurringPattern.create(schedule_window_id: sw7, day_of_week: "5")
RecurringPattern.create(schedule_window_id: sw8, day_of_week: "6")

RecurringPattern.create(schedule_window_id: sw9, day_of_week: "1")
RecurringPattern.create(schedule_window_id: sw10, day_of_week: "2")
RecurringPattern.create(schedule_window_id: sw11, day_of_week: "3")
RecurringPattern.create(schedule_window_id: sw12, day_of_week: "3")

RecurringPattern.create(schedule_window_id: sw13, day_of_week: "6")
RecurringPattern.create(schedule_window_id: sw14, day_of_week: "6")
RecurringPattern.create(schedule_window_id: sw15, day_of_week: "0")
RecurringPattern.create(schedule_window_id: sw16, day_of_week: "0")


LocationRelationship.create(location_id: loc1, driver_id: driver1, rider_id: nil, organization_id: nil)
LocationRelationship.create(location_id: loc2, driver_id: driver1, rider_id: nil, organization_id: nil)
LocationRelationship.create(location_id: loc3, driver_id: driver1, rider_id: nil, organization_id: nil)
LocationRelationship.create(location_id: loc4, driver_id: driver1, rider_id: nil, organization_id: nil)

LocationRelationship.create(location_id: loc5, driver_id: nil, rider_id: rider1, organization_id: nil)
LocationRelationship.create(location_id: loc6, driver_id: nil, rider_id: rider2, organization_id: nil)
LocationRelationship.create(location_id: loc7, driver_id: nil, rider_id: rider3, organization_id: nil)
LocationRelationship.create(location_id: loc8, driver_id: nil, rider_id: rider4, organization_id: nil)

LocationRelationship.create(location_id: loc9, driver_id: nil, rider_id: nil, organization_id: org1.id)
LocationRelationship.create(location_id: loc10, driver_id: nil, rider_id: nil, organization_id: org2.id)

LocationRelationship.create(location_id: loc11, driver_id: driver1, rider_id: nil, organization_id: nil)

LocationRelationship.create(location_id: loc12, driver_id: nil, rider_id: nil, organization_id: nil)
LocationRelationship.create(location_id: loc13, driver_id: nil, rider_id: nil, organization_id: nil)
LocationRelationship.create(location_id: loc14, driver_id: nil, rider_id: nil, organization_id: nil)
LocationRelationship.create(location_id: loc15, driver_id: nil, rider_id: nil, organization_id: nil)




LocationRelationship.create(location_id: loc16, driver_id: driver2, rider_id: nil, organization_id: nil)
LocationRelationship.create(location_id: loc17, driver_id: driver3, rider_id: nil, organization_id: nil)
LocationRelationship.create(location_id: loc18, driver_id: driver3, rider_id: nil, organization_id: nil)
LocationRelationship.create(location_id: loc19, driver_id: driver3, rider_id: nil, organization_id: nil)
LocationRelationship.create(location_id: loc10, driver_id: driver4, rider_id: nil, organization_id: nil)






# ScheduleWindowException(schedule_window_id: "1", is_canceled: true)
