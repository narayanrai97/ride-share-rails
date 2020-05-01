FactoryBot.define do
  factory :rider2 do
    first_name {"Kevin"}
    last_name {"Ride"}
    phone {"919-323-8888"}
    email {"rider2@example.com"}
    password {"Pa$$word20"}
    association :organization
  end
 end
