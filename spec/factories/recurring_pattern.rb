FactoryBot.define do 
   factory :recurring_pattern do 
      factory :recurring_weekly_pattern do
         transient do
            begin_time { Time.now }
         end
         schedule_window { 
            create(:schedule_window, 
                   start_date:  begin_time,
                   end_date:    begin_time + 3.months ,
                   start_time:  begin_time,
                   end_time:    begin_time + 5.hours ,
                   is_recurring: true)
         }
         separation_count { 0 }
         day_of_week { 6 }
         type_of_repeating  { 'weekly' }
      end
   end
end