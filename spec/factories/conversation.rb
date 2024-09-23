FactoryBot.define do
    factory :conversation do
      association :sender, factory: :user
      association :recipient, factory: :user
      
      association :external_member
    end
  end
  