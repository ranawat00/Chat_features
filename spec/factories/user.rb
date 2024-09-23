FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "user#{n}@example.com" }
      password { "password" }
      password_confirmation { "password" }
      first_name { "First" }
      last_name { "Last" }
      # company { "Company" }
      association :company
      company_id { 1 }
    end
  end