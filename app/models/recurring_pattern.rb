class RecurringPattern < ApplicationRecord
  belongs_to :schedule_window
  
  attribute :separation_count, :integer, default: 0
  attribute :type_of_repeating, :string, default: 'weekly'
end
