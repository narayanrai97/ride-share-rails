class ScheduleWindow < ApplicationRecord
  belongs_to :driver
  has_one    :recurring_pattern
  belongs_to :location
  validates :start_time, :end_time, presence: true
  validates :is_recurring, inclusion: {in: [true, false]}
  validates :start_date, :end_date, presence: true, if: :is_recurring?

  validate  :following_dates_cannot_be_in_the_past
  validate  :following_times_cannot_be_overlapped
  validate  :following_dates_cannot_be_overlapped

# Instance methods

  def following_dates_cannot_be_in_the_past
    dates_arr = [start_time, end_time, start_date, end_date]

    dates_arr.each do |dt|
      if dt.present? && dt < Date.today
        if dt == start_time
          errors.add(:start_time, "cannot be in the past")
        elsif dt == end_time
          errors.add(:end_time, "cannot be in the past")
        elsif dt == start_date
          errors.add(:start_date, "cannot be in the past")
        else
          errors.add(:end_date, "cannot be in the past")
        end
      end
    end
  end

  def following_times_cannot_be_overlapped
    if start_time.present? && end_time.present?
      if start_time == end_time
        errors.add(:start_time, "and end time cannot be same")
      end
    end
  end

  def following_dates_cannot_be_overlapped
    if start_date.present? && end_date.present?
      if start_date == end_date
        errors.add(:start_date, "and end date cannot be same")
      end
    end
  end

end
