FactoryBot.define do
  factory :token do
    expires_at { Time.zone.now + 30.days }
    used_at { nil }
    is_valid { true }
    ride_id { nil }

      association :rider
  end
end
