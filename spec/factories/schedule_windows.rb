# FactoryBot.define do
#   factory :schedule_window do
#     start_time { DateTime.now + 1.month }
#     end_time { DateTime.now + 8.hours }
#     start_date { Date.today }
#     end_date { Date.today + 3.months }

#     driver
#     location
#   end
# end

FactoryBot.define do
    factory :schedule_window do
    start_date {Time.now + 1.months }
    end_date {Time.now + 5.months}
    start_time {Time.now + 2.hours}
    end_time {Time.now + 5.hours} 
    is_recurring {false}
    location
    end
end

