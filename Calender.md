In the ride share app, there are two models called ScheduleWindow and RecurringPattern.
RecurringPattern belongs to ScheduleWindow.
In the ScheduleWindow model there is a file call is_recurring
If this field is_recurring is false, the fields for start_date and end_date in the ScheduleWindow model are optional.
If true, this will affect the RecurringPattern model few things to keep in mind:
the separation_count is effected by the type_of_string it is: "daily", "weekly", "monthly", "yearly"


Below is are example of when the is_recurring is true:


# Example of weekly every Saturday from 2pm to 4pm.

ScheduleWindow Model
id: 1
start_date: “2019-09-07"
end_date: “2019-10-21”
start_time: “2019-09-07, 1400"
end_time: “2019-09-07, 1600”
is_recurring: true


RecurringPattern Model
schedule_window_id: 1
separation_count: 0  # The count is 0 due to the fact that it is weekly. If it was set every other week, it would be 1 and so forth.
day_of_week: 6 # The day of week is 6 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
week_of_month: 0 # The week of month is 0 because the example is occuring weekly until the end date. if it occures just on a particularly week than it would be 1 through 4. See examples below.
month_of_year: 0  # The month of year is set to 0 because it is not recurring once a month every year.
type_of_repeating: “Weekly” # The type of repeating is set to weekly because this event occures weekly. 

# Example of every other week on Tuesday from 2pm to 4pm:

ScheduleWindow Model
id: 2
start_date: “2019-09-03"
end_date: “2019-09-30”
start_time: “2019-09-03, 1400"
end_time: “2019-09-03, 1600”
is_recurring: true

RecurringPattern Model
schedule_window_id: 2
separation_count: 1  # The count is 1 due to the fact that it is occuring every other week.
day_of_week: 2 # The day of week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
week_of_month: 0 # The week of month is 0 because the example is occures every other week until the end date.
month_of_year: 0  # The month of year is set to 0 because it is not recurring once a month every year.
type_of_repeating: “weekly” # The type of repeating is set to daily because the schedule window above recurs weekly. 



# Example of monthly, every two weeks on Tuesday, every other month.

ScheduleWindow Model
id: 3
start_date: “2019-09-10"
end_date: “2019-12-30”
start_time: “2019-09-10, 1400"
end_time: “2019-09-10, 1600”
is_recurring: true

RecurringPattern Model
schedule_window_id: 3
separation_count: 1  # The separtion_count is 1 since it occures every other month.
day_of_week: 2 # The day of week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
week_of_month: 2 # The week of month is 2 because the example is occures every month.
month_of_year: 0  # The month of year is set to 0 because it is not recurring once a month every year.
type_of_repeating: “Monthly” # The type of repeating is set to monthly because the schedule window above recurs monthly. 

# Example of monthly, every 3 months, every three weeks, on Tuesday,

ScheduleWindow Model
id: 4
start_date: “2019-09-10"
end_date: “2022-12-30”
start_time: “2019-09-10, 1400"
end_time: “2019-09-10, 1600”
is_recurring: true

RecurringPattern Model
schedule_window_id: 4
separation_count: 3  # The separtion_count is 3 since it occures every three months.
day_of_week: 2 # The day of week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
week_of_month: 3 # The week of month is 3 because the example is occures every third week.
month_of_year: 0  # The month of year is set to 0 because it is not recurring once a month every year.
type_of_repeating: “Monthly” # The type of repeating is set to monthly because the schedule window above recurs monthly. 

# Example of yearly, week two on Tuesday of January, every year

ScheduleWindow Model
id: 5
start_date: “2019-09-10"
end_date: “2022-12-30”
start_time: “2019-09-10, 1400"
end_time: “2019-09-10, 1600”
is_recurring: true

RecurringPattern Model
schedule_window_id: 5
separation_count: 0  # The count is 0 due to the fact that it is occuring every year.
day_of_week: 2 # The day of week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
week_of_month: 2 # The week of month is 2 because the example is occuring every second week.
month_of_year: 1  # The month of year is set to 1 because it is recurring on the first month of the year.
type_of_repeating: “yearly” # The type of repeating is set to daily because the schedule window above recurs yearly. 

# Example of yearly, week three on Tuesday of March, every other year

ScheduleWindow Model
id: 6
start_date: “2019-09-10"
end_date: “2030-12-30”
start_time: “2019-09-10, 1400"
end_time: “2019-09-10, 1600”
is_recurring: true

RecurringPattern Model
schedule_window_id: 6
separation_count: 1  # The count is 1 due to the fact that it is occuring every other year.
day_of_week: 2 # The day of week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
week_of_month: 3 # The week of month is 3 because the example is occures every third week.
month_of_year: 3  # The month of year is set to 3 because it is recurring on the third month of the year.
type_of_repeating: “yearly” # The type of repeating is set to daily because the schedule window above recurs yearly. 