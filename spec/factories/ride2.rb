FactoryBot.define do
    factory :ride2 do
      pick_up_time { Date.today + 6 }
      reason {"Interview"}
      status { "pending"}

    end
end
