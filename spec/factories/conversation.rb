FactoryBot.define do
    factory :conversation do
      association :sender, factory: :user
      association :recipient, factory: :user
      
      # If you need associations, they should be created properly
    #   association :external_chat
    #   association :external_member
    end
  end
  