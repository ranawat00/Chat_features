FactoryBot.define do
  factory :external_chat do
    email { Faker::Internet.email }
    association :user
    association :external_member
    association :conversation # Only if required
    body { "Hello, this is a message" }
  end
end
