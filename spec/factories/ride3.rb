FactoryBot.define do
  # byebug
    factory :ride3, class: Ride do
      rider_id {FactoryBot.create(:rider, organization_id: 1).id}
      pick_up_time { Date.today + 6.days }
      start_location_id {FactoryBot.create(:location).id}
      end_location_id {FactoryBot.create(:location).id}
      reason {Faker::Artist.name}
      status {"approved"}
      round_trip {false}
      # organization

    end
end
