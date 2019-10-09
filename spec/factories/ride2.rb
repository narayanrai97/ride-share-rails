FactoryBot.define do
    factory :ride2 do
      pick_up_time { Date.today + 6.days }
      reason {"Interview"}
      status { "pending"}

    end
end
