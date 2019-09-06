FactoryBot.define do
    factory :driver do
       sequence(:email) { |id| "user#{id}@sample.com"}
       password {'password'}
       first_name { 'Ben' }
       last_name {'smith'}
       phone {'3367867121'}
       organization
    end
end