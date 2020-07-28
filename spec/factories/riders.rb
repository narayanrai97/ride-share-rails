FactoryBot.define do
  factory :rider do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    phone {"9199998888"}
    email {Faker::Name.first_name+"@gmail.com"}
    password {"Pa$$word20"}
    association :organization
  end

  # We may not need the following. I may implement the faker gem instead.
  # #
  # factory :rider2, class: Rider do
  #   first_name {"Lyfted"}
  #   last_name {"Rider"}
  #   phone {"919-111-2222"}
  #   email {"rider2@example.com"}
  #   password {"password"}
  #   association :organization2
  # end
end
