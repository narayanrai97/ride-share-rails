class Vehicle < ApplicationRecord
  belongs_to :driver
  has_one_attached :image

  validates :car_make, :car_model, :car_color, :car_year, :car_state, :car_plate, :seat_belt_num,
            :insurance_provider, :insurance_start, :insurance_stop, presence: true
  validates :car_year, numericality: { only_integer: true }
  validates :seat_belt_num, numericality: { only_integer: true }
  validates :car_plate, uniqueness: true
  validate  :insurance_stop_cannot_be_in_the_past
  validate :image_type

  def thumbnail
    return self.image.variant(resize: '300x300>').processed
  end

  def image_type
    if (image.attached? && !image.content_type.in?(['image/jpg','image/png']))
      errors.add(:image, "needs to be JPEG or PNG")
    end
  end

  def insurance_stop_cannot_be_in_the_past
    if insurance_stop.present? && insurance_stop < Date.today
      errors.add(:insurance_stop, "date can't be in the past")
    end
  end

  def car_info
    "#{car_year} #{car_make} #{car_model}"
  end
end
