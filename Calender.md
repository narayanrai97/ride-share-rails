In the ride share app, you will find that there are two models called Schedule_window and Recurring_pattern. 
Recurring_pattern belongs to Schedule_window. Recurring_pattern can either be true or false. 
If Recurring_pattern is false than the filds for start_date and end_date in the schedule_windows model
is opitional. if its true this will effect the Recurring_pattern. Below are examples of when its true.



# This mean that every saturday you will like to drive between the requested time. 
Schedule_window Model  
id: 1
start_date: "2019-09-07"
end_date: "2019-10-21"
start_time: "2019-09-07, 1400"
start_time: "2019-09-07, 1600"
is_recurring: "true"


# By default the recurring pattern is set to daily. 
Recurring_pattern Model 
schedule_window_id: 1 
separation_count: "0" # The count is 0 due to the fact that it is daily. if its was every other week it will 1, and so forth
day_of_week: "6" # The day of the week is 6 due to the fact that were using the wday, which count the days of the week (0..6) for sunday to saturday
week_of_month: "0" # Week of the month is 0 due to that its one once a week a month, but the example is daily until the end date
month_of_year: "0" # Set to 0 due to that its not every month once a year. 
type_of_repeating: "Daily" Set daily due to the fact that it per week. 


