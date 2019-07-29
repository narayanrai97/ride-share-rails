FactoryBot.define do
    factory :driver do
       email {'v1@sample.com'}
       password {'password'}
       first_name { 'Ben' }
       last_name {'smith'}
       phone {'666-111-2222'}
       organization
    end
end