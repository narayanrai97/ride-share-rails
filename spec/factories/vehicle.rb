FactoryBot.define do
    factory :vehicle do
      car_make { "Nissan"}
      car_model {"Altima"}
      car_color {"Silver"}
      car_year {2010}
      car_plate {"ZQWOPQ"}
      seat_belt_num {4}
      insurance_provider {"Geico"}
      insurance_start {"2019-05-19"}
      insurance_stop {"2020-05-19"}

    end
end
