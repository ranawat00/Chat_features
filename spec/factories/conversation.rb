FactoryBot.define do
    factory :conversation do
      association :sender, factory: :user
      association :recipient, factory: :user
      # association :external_chat, factory: :external_chat
      association :external_member, factory: :external_member
    end
  end
  