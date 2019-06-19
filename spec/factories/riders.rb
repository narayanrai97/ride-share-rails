FactoryBot.define do
  factory :rider do
    first_name { "Ubber" }
    last_name { "Rider"}
    phone { "919-999-8888" }
    email { "rider@example.com" }
    password { "password" }

      association :organization
  end
end
