FactoryBot.define do
    factory :message do
        body { "Sample message body" }
      association :user
      association :conversation
      # association :external_member
    end
  end