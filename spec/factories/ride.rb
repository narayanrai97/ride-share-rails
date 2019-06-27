FactoryBot.define do
    factory :ride do
      pick_up_time {"2019-02-19 15:30:00"}
      reason {"Interview"}
      status { "pending"}

    end
end
