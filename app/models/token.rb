class Token < ApplicationRecord
  belongs_to :ride, optional: true
  belongs_to :rider
end
