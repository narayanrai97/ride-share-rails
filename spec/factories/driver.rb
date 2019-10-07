FactoryBot.define do
    factory :driver do
       sequence(:email) { |id| "user#{id}@sample.com"}
       password {'password'}
       first_name { 'Ben' }
       last_name {'smith'}
       phone {'336-786-7121'}
       organization
    end
end
