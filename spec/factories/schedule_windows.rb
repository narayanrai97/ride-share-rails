FactoryBot.define do
  factory :schedule_window do
    start_time { Date.today }
    end_time { Date.today + 8.hours }
    start_date { Date.today }
    end_date { Date.today + 3.months }

    driver
    location
  end
end
