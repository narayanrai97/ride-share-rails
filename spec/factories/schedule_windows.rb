FactoryBot.define do
  factory :schedule_window do
    start_time { Date.today }
    end_time { Date.today + 8.hours }
    start_date { "2019-07-27" }
    end_date { "2019-07-30" }

    driver
    location
  end
end
