class ScheduleWindow < ApplicationRecord
  belongs_to :driver
  has_one    :recurring_pattern
  belongs_to :location
  validates :start_time, :end_time, presence: true
  validates :start_date, :end_date, presence: true, if: :is_recurring?

  validate  :dates_cannot_be_in_the_past
  validate  :end_time_after_start_time
  validate  :end_date_after_start_date
  validate  :start_date_cannot_be_later_than_start_time
  validate  :end_date_cannot_be_before_end_time

# Instance methods

  def dates_cannot_be_in_the_past
    if start_time.present? && start_time < DateTime.now
        errors.add(:start_time, "cannot be in the past")
    end

    if end_time.present? && end_time < DateTime.now
      errors.add(:end_time, "cannot be in the past")
    end

    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "cannot be in the past")
    end

    if end_date.present? && end_date < Date.today
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
      if start_date == end_date && is_recurring == true
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

  def events(query_start_date, query_end_date)
    if is_recurring
      recurring_event(query_start_date, query_end_date)
    else
      nonrecurring_event(query_start_date, query_end_date)
    end
  end

  def nonrecurring_event(query_start_date, query_end_date)
    if query_start_date <= start_time && end_time < query_end_date
      [{
        eventId: id,
        startTime: start_time,
        endTime: end_time,
        isRecurring: false,
        location: location
      }]
    else
      []
    end
  end

  def recurring_event(query_start_date, query_end_date)
    case recurring_pattern.type_of_repeating
    when 'weekly'
      recurring_weekly(query_start_date, query_end_date)
    else
      return []
    end
  end

  def recurring_weekly(query_start_date, query_end_date)

    current_start_date = query_start_date < start_date ? start_date : query_start_date
    dow = recurring_pattern.day_of_week
    start_dow = current_start_date.to_datetime.wday

    if start_dow <= dow
      current = current_start_date.to_datetime + (dow - start_dow).days
    else
      current = current_start_date.to_datetime + (7 - (start_dow - dow)).days
    end

    results = []
    while current <= query_end_date && current <= end_date
      results.unshift({
        eventId: id,
        startTime: current.strftime('%Y-%m-%d') + " " + start_time.strftime('%H:%M'),
        endTime: current.strftime('%Y-%m-%d') + " " + end_time.strftime('%H:%M'),
        isRecurring: true,
        location: location
      })
      current = current + (7 * (recurring_pattern.separation_count + 1)).days
    end

    return results

  end
end
