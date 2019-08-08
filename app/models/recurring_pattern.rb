class RecurringPattern < ApplicationRecord
  belongs_to :schedule_window
  validates :type_of_repeating, inclusion: { in: %w(daily weekly monthly yearly),
    message: "%{value} is not a valid type of repeating" }
    
  attribute :separation_count, :integer, default: 0
  attribute :type_of_repeating, :string, default: 'weekly'
end
