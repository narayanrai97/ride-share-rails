FactoryBot.define do 
   factory :recurring_pattern do 
      schedule_window
      separation_count {2}
      day_of_week {7}
      week_of_month {4}
      month_of_year {6}
      type_of_repeating {"2"}
   end
end