class Vehicle < ApplicationRecord
  belongs_to :driver

  validates :car_make, :car_model, :car_color, :car_year, :car_plate, :seat_belt_num,
            :insurance_provider, :insurance_start, :insurance_stop, presence: true
  validates :car_color, inclusion: { in: %w(red black white blue silver burgandy yellow gold gray green brown),
                                message: "%{value} is not a valid car color" }
  validates :car_year, numericality: { only_integer: true }
  validate  :insurance_stop_cannot_be_in_the_past


  def insurance_stop_cannot_be_in_the_past
    if insurance_stop.present? && insurance_stop < Date.today
      errors.add(:insurance_stop, "date can't be in the past")
    end
  end
end
