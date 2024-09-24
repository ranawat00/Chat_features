FactoryBot.define do
    factory :conversation do
      sender { association(:user) }  
      recipient { association(:user) }  
      body { "Sample content" }
      sender_id { 1 }
    recipient_id { 2 }
      
      # association :external_member
    end
  end
  