FactoryBot.define do
  factory :schedule_window do
    start_time { Date.today }
    end_time { Date.today + 8.hours }

    driver
    location
    organization
  end
end
