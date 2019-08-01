FactoryBot.define do
  factory :schedule_window do
    start_time { DateTime.now }
    end_time { DateTime.now + 8.hours }
    start_date { Date.today }
    end_date { Date.today + 3.months }
    is_recurring { false }

    driver
    location
  end
end

# (byebug) start_time
# Thu, 25 Jul 2019 09:00:00 UTC +00:00

# (byebug) DateTime.now
# Tue, 30 Jul 2019 15:52:42 -0400