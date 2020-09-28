FactoryBot.define do
    factory :driver2, class: Driver do
       sequence(:email) { |id| "sample#{id}@gmail.com"}
       password {'Pa$$word100!'}
       first_name { 'Jeff' }
       last_name {'brown'}
       phone {'3363451570'}
       organization
    end
end
