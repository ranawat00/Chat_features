FactoryBot.define do
  factory :external_chat do
    email { "external_chat@example.com" }
    association :user
    association :conversation
    association :external_member
    body { "Hello, this is a message" }
  end
end
