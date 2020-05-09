FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "Pa$$word20" }

    association :organization
  end
end
