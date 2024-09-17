FactoryBot.define do
    factory :external_member do
        # user { association :user } 
        name { "John Doe" }
        sequence(:email) { |n| "external_member#{n}@example.com" }
    end
end