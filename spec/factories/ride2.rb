FactoryBot.define do
    factory :ride2, class: Ride do
      rider_id {FactoryBot.create(:rider).id}
      driver_id {FactoryBot.create(:driver).id}
      pick_up_time { Date.today + 6.days }
      start_location_id {FactoryBot.create(:location).id}
      end_location_id {FactoryBot.create(:location).id}
      reason {Faker::Artist.name}
      status {"approved"}
      round_trip {true}
      organization

    end
end
