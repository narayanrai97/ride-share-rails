FactoryBot.define do
    factory :schedule_window do
        start_date { Time.now + 1.month }
        end_date   { Time.now + 5.months }
        start_time { Time.now + 1.month + 2.hours}
        end_time   { Time.now + 1.month + 5.hours } 
        is_recurring { false }
        location
        driver
    end
end

