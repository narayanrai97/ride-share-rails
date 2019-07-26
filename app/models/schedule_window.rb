class ScheduleWindow < ApplicationRecord
  belongs_to :driver
  has_one    :recurring_pattern
  belongs_to :location
  validates :start_time, :end_time, :is_recurring, presence: true
  validates :start_date, :end_date, presence: true, if: :is_recurring?

  validate  :dates_cannot_be_in_the_past
  validate  :end_time_after_start_time
  validate  :end_date_after_start_date
  validate  :start_date_cannot_be_later_than_start_time
  validate  :end_date_cannot_be_before_end_time

# Instance methods

  def dates_cannot_be_in_the_past
    if start_time < DateTime.now
        errors.add(:start_time, "cannot be in the past")
    end

    if end_time < DateTime.now
      errors.add(:end_time, "cannot be in the past")
    end

    if start_date < Date.today
      errors.add(:start_date, "cannot be in the past")
    end

    if end_date < Date.today
      errors.add(:end_date, "cannot be in the past")
    end
  end

  def end_time_after_start_time
    if start_time.present? && end_time.present?
      if start_time == end_time
        errors.add(:end_time, "cannot be same as start time")
      elsif start_time > end_time
        errors.add(:start_time, "cannot be later than end time")
      else
        true
      end
    end
  end

  def end_date_after_start_date
    if start_date.present? && end_date.present?
      if start_date == end_date
        errors.add(:end_date, "cannot be same as start date")
      elsif start_date > end_date
        errors.add(:start_date, "cannot be later than the end date")
      else
        true
      end
    end
  end

  def start_date_cannot_be_later_than_start_time
    if start_date.present? && start_time.present?
      if start_date > start_time
        errors.add(:start_date, "cannot be later than start time")
      end
    end
  end

  def end_date_cannot_be_before_end_time
    if end_date.present? && end_time.present?
      if end_date < end_time
        errors.add(:end_date, "cannot be before end time")
      end
    end
  end

end
