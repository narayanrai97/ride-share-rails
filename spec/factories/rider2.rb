FactoryBot.define do
  factory :rider2 do
    first_name {"Kevin"}
    last_name {"Ride"}
    phone {"919-323-8888"}
    email {Faker::Name.first_name+"@gmail.com"}
    password {"Pa$$word20"}
     is_active {true}
    association :organization
  end
 end
