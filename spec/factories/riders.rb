FactoryBot.define do
  factory :rider do
    first_name {"Ubber"}
    last_name {"Rider"}
    phone {"919-999-8888"}
    email {"rider@example.com"}
    password {"password"}
    association :organization
  end

  factory :rider2, class: Rider do
    first_name {"Lyfted"}
    last_name {"Rider"}
    phone {"919-111-2222"}
    email {"rider2@example.com"}
    password {"password"}
    association :organization2
  end
end
