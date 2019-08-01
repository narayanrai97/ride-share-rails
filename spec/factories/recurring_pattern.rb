FactoryBot.define do 
   factory :recurring_pattern do 
      factory :recurring_weekly_pattern do
         schedule_window { 
            create(:schedule_window, 
                   start_date: '2019-09-07', 
                   end_date: '2019-10-21', 
                   start_time: '2019-09-07 14:00', 
                   end_time: '2019-09-07 16:00',
                   is_recurring: true)
         }
         separation_count { 0 }
         day_of_week { 6 }
         type_of_repeating  { 'weekly' }
      end
   end
end