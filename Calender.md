> In the Ride Share App, there are two models called ScheduleWindow and RecurringPattern.
RecurringPattern belongs to ScheduleWindow.
In the ScheduleWindow model there is a field called is_recurring.
If this field is_recurring is false, the fields for start_date and end_date in the ScheduleWindow model are optional.
If true, this will affect the RecurringPattern model, just a few things to keep in mind:
the separation_count is affected by the type_of_string it is: "daily", "weekly", "monthly", "yearly". 


**Below are examples of when the field is_recurring is true:**
___
### Example of a weekly recurring. Occurs every Saturday from 2pm to 4pm.
____
#### SchedulWindow Model 
| Field      | Value |
|   :---:        |    :----:   |  
| id     | 1     | 
| start_date   |    “2019-09-07" |  
| end_date      |  “2019-10-21” |
|start_time    |“2019-09-07 1400"|
|end_time       | “2019-09-07 1600”|

#### RecurringPattern Model
| Field      | Value | 
|   :---:       |   :----:   |  
|schedule_window_id: |1      | 
|separation_count|  0        | 
|day_of_week | 6  |
|week_of_month| 0 |
|month_of_year| 0  |
|type_of_repeating| “weekly” |

* The separation_count is 0 due to the fact that it is weekly.
* The day_of_week is 6 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
 * The week_of_month is 0 because the example is occurring weekly until the end date
* The month_of_year is set to 0 because it is not recurring once a month every year
 * The type_of_repeating is set to weekly because this event occurs weekly. 
 _____
#### Example of a weekly recurring. Occurs every other week, on Tuesday from 2pm to 4pm:
_____
#### ScheduleWindow Model
| Field | Value|
|:---:  |:---:|
|id     | 2   |
|start_date | “2019-09-03"|
|end_date | “2019-09-30” |
|start_time | “2019-09-03 1400"|
|end_time | “2019-09-03 1600” |
|is_recurring | true  |

#### RecurringPattern Model
| Field | Value|
|:---:  |:---:|
|schedule_window_id| 2 |
|separation_count| 1   |
|day_of_week| 2  |
|week_of_month| 0  | 
|month_of_year| 0  |
|type_of_repeating| “weekly” |

* The sparation_count is 1 due to the fact that it is occuring every other week.
* The day_of_week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
* The week_of_month is 0 because the example is occuring every other week until the end date.
* The month_of_year is set to 0 because it is not recurring once a month every year.
* The type_of_repeating is set to weekly because the schedule window above recurs weekly. 
_____
### Example of a monthly recurring. Occurs every month, on Tuesday:
_____

#### ScheduleWindow Model
| Field | Value|
|:---:  |:---:|
|id |  3 |
|start_date | “2019-09-10" |
|end_date | “2019-12-30” |
|start_time | “2019-09-10 1400" |
|end_time | “2019-09-10 1600” |
|is_recurring | true |

####  RecurringPattern
| Field | Value|
|:---:  |:---:|
|schedule_window_id| 3 |
|separation_count| 0   |
|week_of_month| 2      |.
|week_of_month| 0   | 
|month_of_year| 0    |
|type_of_repeating| "monthly" |

* The separation_count is set to 0 since it occurs every month.
* The day_of_week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
* The week_of_month is 0 because the example is occuring every other week until the end date.
 The month_of_year is set to 0 because it is not recurring once a month every year.
 * The type_of_repeating is set to monthly because the schedule_window above recurs monthly.
_____
#### Example of a monthly recurring. Occurs every other month, every second week, on Tuesday
______
#### ScheduleWindow Model
| Field | Value|
|:---:  |:---:|
|id     | 4   |
|start_date| “2019-09-10" |
|end_date| “2019-12-30”  |
|start_time | “2019-09-10 1400" |
|end_time | “2019-09-10 1600” |
|is_recurring| true   |

#### RecurringPattern Model
| Field | Value|
|:---:  |:---:|
|schedule_window_id| 4 |
|separation_count| 1    |# The separtion_count is 1 since it occurs every other month.
|day_of_week|     2   |
|week_of_month|  2    |
|month_of_year| 0     |
|type_of_repeating| “monthly” |

* The separtion_count is 1 since it occurs every other month.
* The day_of_week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
* The week_of_month is 2 because the example is occurs every month.
* The month_of_year is set to 0 because it is not recurring once a month every year.
* The type_of_repeating is set to monthly because the schedule window above recurs monthly. 
_____
### Example of a monthly recurring. Occurs every three months, every third week, on Tuesday.
______

#### ScheduleWindow Model
| Field | Value|
|:---:  |:---:|
|id | 5  |
|start_date| “2019-09-10"|
|end_date| “2022-12-30”|
|start_time| “2019-09-10 1400"|
|end_time| “2019-09-10 1600”|
|is_recurring| true|

#### RecurringPattern Model
| Field | Value|
|:---:  |:---:|
|schedule_window_id | 5 |
|separation_count  |3   |  
|day_of_week | 2   | 
|week_of_month| 3  | 
|month_of_year| 0  | 
|type_of_repeating | “monthly” | 

* The separtion_count is 3 since it occurs every three months.
* The day_of_week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
* The week_of_month is 3 because the example is occurs every third week.
* The month_of_year is set to 0 because it is not recurring once a month every year.
* The type_of_repeating is set to monthly because the schedule window above recurs monthly. 

_____
### Example of a yearly recurring. Occurs every second week of January on Tuesday .
_____
#### ScheduleWindow Model
| Field | Value|
|:---:  |:---:|
|id  | 6     |
|start_date | “2019-09-10" |
|end_date | “2022-12-30” |
|start_time| “2019-09-10 1400" |
|end_time| “2019-09-10 1600” |
|is_recurring | true | 

#### RecurringPattern Model
| Field | Value|
|:---:  |:---:|
|schedule_window_id |  6 |
|separation_count | 0  | 
|day_of_week | 2   |
|week_of_month | 2  | 
|month_of_year | 1  | 
|type_of_repeating| “yearly” | T
* The separation_count is 0 due to the fact that it is occuring every year.
* The day_of_week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
* The week_of_month is 2 because the example is occuring every second week.
* The month_of_year is set to 1 because it is recurring on the first month of the year.
* The type_of_repeating is set to yearly because the schedule window above recurs yearly. 
_____
### Example of a yearly recurring. Occurs every other year, on the third week of March, on Tuesday.
____

#### ScheduleWindow Model
| Field | Value|
|:---:  |:---:|
|id| 7  |
|start_date| “2019-09-10"|
|end_date| “2030-12-30”|
|start_time| “2019-09-10 1400"|
|end_time| “2019-09-10 1600”|
|is_recurring| true|

#### RecurringPattern Model
| Field | Value|
|:---:  |:---:|
|schedule_window_id| 7 |
|separation_count|  1 |
|day_of_week | 2    |
|week_of_month| 3  |
|month_of_year| 3  | 
|type_of_repeating| “yearly” |

*  The sparation_count is 1 due to the fact that it is occuring every other year.
*  The day_of_week is 2 because we are using the “wday” method which counts the days of the week (0..6) form Sunday to Saturday.
*  The week_of_month is 3 because the example is occurs every third week.
*  The month_of_year is set to 3 because it is recurring on the third month of the year.
*  The type_of_repeating is set to yearly because the schedule window above recurs yearly. 
