# spec/models/conversation_spec.rb

require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:conversation) { build(:conversation, sender: user1, recipient: user2) }

  describe 'associations' do
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:recipient).class_name('User') }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe 'validations' do
    it 'validates presence of sender' do
      conversation.sender = nil
      expect(conversation).not_to be_valid
      expect(conversation.errors[:sender]).to include("must exist")
    end

    it 'validates presence of recipient' do
      conversation.recipient = nil
      expect(conversation).not_to be_valid
      expect(conversation.errors[:recipient]).to include("must exist")
    end

    # it 'validates uniqueness of sender_id scoped to recipient_id' do
    #   create(:conversation, sender: user1, recipient: user2)
    #   conversation = build(:conversation, sender: user1, recipient: user2)
    #   expect(conversation).not_to be_valid
    #   expect(conversation.errors[:sender_id]).to include("has already been taken")
    # end
  end

  describe '.between' do
    # it 'returns conversations between two users' do
    #   create(:conversation, sender: user1, recipient: user2)
    #   create(:conversation, sender: user2, recipient: user1)
    #   expect(Conversation.between(user1.id, user2.id).count).to eq(2)
    # end

    it 'does not return conversations not involving the users' do
      user3 = create(:user)
      create(:conversation, sender: user1, recipient: user3)
      expect(Conversation.between(user1.id, user2.id).count).to eq(0)
    end
  end
end
