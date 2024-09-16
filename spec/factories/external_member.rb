FactoryBot.define do
    factory :external_member do
     
        name { "John Doe" }
        sequence(:email) { |n| "external_member#{n}@example.com" }
    end
end