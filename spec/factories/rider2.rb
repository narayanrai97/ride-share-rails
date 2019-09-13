FactoryBot.define do
  factory :rider2 do
    first_name {"Kevin"}
    last_name {"Ride"}
    phone {"919-323-8888"}
    email {"rider2@example.com"}
    password {"password"}
    association :organization
  end
 end
