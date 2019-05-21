class ScheduleWindowSerializer < ActiveModel::Serializer
  attributes :id, :driver_id, :start_date, :end_date, :start_time, :end_time, :location, :is_recurring

end