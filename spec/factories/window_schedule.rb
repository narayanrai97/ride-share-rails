FactoryBot.define do
    factory :schedule_window do
    start_date {Time.now + 3.months }
    end_date {Time.now + 5.months}
    start_time {Time.now + 2.hours}
    end_time {Time.now + 5.hours} 
    is_recurring {false}
    location
   end
end

