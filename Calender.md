In the ride share app, there are two models called ScheduleWindow and RecurringPattern.
RecurringPattern belongs to ScheduleWindow.
In the ScheduleWindow model there is a file call is_recurring
If this field is_recurring is false, the fields for start_date and end_date in the ScheduleWindow model are optional.
If true, this will affect the RecurringPattern model.

Below is are example of when the is_recurring is true:

# The following means that the driver would like to drive every Saturday from 2pm to 4pm.

ScheduleWindow Model
id: 1
start_date: “2019-09-07"
end_date: “2019-10-21”
start_time: “2019-09-07, 1400"
end_time: “2019-09-07, 1600”
is_recurring: true


# By default, the recurring pattern is set to daily.

RecurringPattern Model
schedule_window_id: 1
separation_count: 0  # The count is 0 due to the fact that it is daily. If it was set every other week, it would be 1 and so forth.
day_of_week: 6 # The day of week is 6 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
week_of_month: 0 # The week of month is 0 because the example is daily until the end date.
month_of_year: 0  # The month of year is set to 0 because it is not recurring once a month every year.
type_of_repeating: “Daily” # The type of repeating is set to daily because the schedule window above recurs daily. 

Example of every other week:

ScheduleWindow Model
id: 2
start_date: “2019-09-02"
end_date: “2019-09-30”
start_time: “2019-09-02, 1400"
end_time: “2019-09-02, 1600”
is_recurring: true

RecurringPattern Model
schedule_window_id: 2
separation_count: 1  # The count is 1 due to the fact that it is occuring every other week.
By default the separation_count is set (0) which is daily. So 1 will jump a week and we recure every other week.
day_of_week: 1 # The day of week is 1 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
week_of_month: 0 # The week of month is 0 because the example is occures every week until the end date.
month_of_year: 0  # The month of year is set to 0 because it is not recurring once a month every year.
type_of_repeating: “Every other week” # The type of repeating is set to daily because the schedule window above recurs daily. 

example of monthly on the second Tuesday of the week
ScheduleWindow Model
id: 3
start_date: “2019-09-10"
end_date: “2019-12-30”
start_time: “2019-09-10, 1400"
end_time: “2019-09-10, 1600”
is_recurring: true

RecurringPattern Model
schedule_window_id: 3
separation_count: 4 # The count is 1 due to the fact that it is occuring every other week.
By default the separation_count is set (0) which is daily. So 1 will jump a week and we recure every other week.
day_of_week: 1 # The day of week is 1 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
week_of_month: 0 # The week of month is 0 because the example is occures every week until the end date.
month_of_year: 0  # The month of year is set to 0 because it is not recurring once a month every year.
type_of_repeating: “Every other week” # The type of repeating is set to daily because the schedule window above recurs daily. 