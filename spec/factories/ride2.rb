FactoryBot.define do
    factory :ride2 do
      rider_id {FactoryBot.create(:rider).id}
      pick_up_time { Date.today + 6.days }
      start_location_id {FactoryBot.create(:location).id}
      end_location_id {FactoryBot.create(:location).id}
      reason {Faker::Artist.name}
      status {"approved"}
      round_trip {true}
      organization

    end
end
