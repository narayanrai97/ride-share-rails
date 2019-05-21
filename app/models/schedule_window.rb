class ScheduleWindow < ApplicationRecord

  belongs_to :driver

  has_one :recurring_pattern
  belongs_to :location

end
