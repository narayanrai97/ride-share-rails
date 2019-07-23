In the ride share app, there are two models called Schedule_window and Recurring_pattern.
Recurring_pattern belongs to Schedule_window.
Recurring_pattern can either be true or false.
If Recurring_pattern is false, the fields for start_date and end_date in the schedule_window model are optional.
If true, this will affect the Recurring_pattern model.

Below is an example of when the recurring is true:

# The following means that the driver would like to drive between the requested times every Saturday.

Schedule_window Model
id: 1
start_date: “2019-09-07"
end_date: “2019-10-21”
start_time: “2019-09-07, 1400"
end_time: “2019-09-07, 1600”
is_recurring: true


# By default, the recurring pattern is set to daily.

Recurring_pattern Model
schedule_window_id: 1
separation_count: “0" # The count is 0 due to the fact that it is daily. If it was set every other week, it would be 1 and so forth.
day_of_week: “6” # The day of week is 6 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
week_of_month: “0” # The week of month is 0 because the example is daily until the end date.
month_of_year: “0" # The month of year is set to 0 because it is not recurring once a month every year.
type_of_repeating: “Daily” # The type of repeating is set to daily because the schedule window above recurres daily. 
