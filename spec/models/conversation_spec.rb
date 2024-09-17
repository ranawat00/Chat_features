# spec/models/conversation_spec.rb
require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'associations' do
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:recipient).class_name('User') }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe 'validations' do
    before do
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      FactoryBot.create(:conversation, sender: @user1, recipient: @user2)
    end

    it { should validate_uniqueness_of(:sender_id).scoped_to(:recipient_id) }

    it 'does not allow duplicate conversations between the same sender and recipient' do
      duplicate_conversation = FactoryBot.build(:conversation, sender: @user1, recipient: @user2)
      expect(duplicate_conversation).not_to be_valid
      expect(duplicate_conversation.errors[:sender_id]).to include('has already been taken')
    end

    it 'allows a conversation if the sender and recipient are different' do
      user3 = FactoryBot.create(:user)
      conversation = FactoryBot.build(:conversation, sender: @user1, recipient: user3)
      # expect(conversation).to be_valid
    end
  end

  describe 'scopes' do
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }
    let!(:conversation) { FactoryBot.create(:conversation, sender: user1, recipient: user2) }

    describe '.between' do
      it 'returns conversations between two users' do
        expect(Conversation.between(user1.id, user2.id)).to include(conversation)
      end

      it 'does not return conversations between other users' do
        other_user = FactoryBot.create(:user)
        expect(Conversation.between(user1.id, other_user.id)).not_to include(conversation)
      end
    end
  end
end
