FactoryBot.define do
    factory :vehicle do
      car_make { "Nissan"}
      car_model {"Altima"}
      car_color {"Silver"}
      car_year {2010}
      car_state {"NY"}
      car_plate {Faker::Name.unique.last_name}
      seat_belt_num {4}
      insurance_provider {"Geico"}
      insurance_start { Date.today }
      insurance_stop { Date.today + 6.months }

    end
end
