FactoryBot.define do
    factory :schedule_window do
   start_date {"02-01-2019"}
    end_date {"05-03-2019"}
    start_time {"09-03-2019"}
    end_time {"10-02-2019"} 
    is_recurring {false}
    location_id {"2"}
   end
end
