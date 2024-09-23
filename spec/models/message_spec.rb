# spec/models/message_spec.rb

require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:user) { create(:user) }
  let!(:conversation) { create(:conversation, sender: user, recipient: user) }
  let!(:message) { build(:message, user: user, conversation: conversation) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:conversation) }
    # Uncomment if you decide to add external_member later
    # it { should belong_to(:external_member).optional }
  end

  describe 'validations' do
    it 'validates presence of user' do
      message.user = nil
      expect(message).not_to be_valid
      expect(message.errors[:user]).to include("must exist")
    end

    it 'validates presence of body' do
      message.body = nil
      expect(message).not_to be_valid
      expect(message.errors[:body]).to include("can't be blank")
    end

    it 'validates presence of conversation' do
      message.conversation = nil
      expect(message).not_to be_valid
      expect(message.errors[:conversation]).to include("must exist")
    end
  end

  describe 'valid message creation' do
    it 'is valid with valid attributes' do
      message.body = 'This is a valid message.'
      expect(message).to be_valid
    end
  end
end
