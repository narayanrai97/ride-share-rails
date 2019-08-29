FactoryBot.define do 
   factory :recurring_pattern do 
      factory :recurring_weekly_pattern do
         schedule_window { 
            create(:schedule_window, 
                   start_date: '2025-09-06', 
                   end_date: '2025-10-19', 
                   start_time: '2025-09-06 14:00', 
                   end_time: '2025-09-06 16:00',
                   is_recurring: true)
         }
         separation_count { 0 }
         day_of_week { 6 }
         type_of_repeating  { 'weekly' }
      end
   end
end