require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { should belong_to(:conversation) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
  end

  describe 'valid message' do
    let(:user) { create(:user) }
    let(:conversation) { create(:conversation) }
    let(:message) { build(:message, body: 'Hello') }

    it 'is valid with valid attributes' do
      expect(message).to be_valid
    end
  end


  describe 'invalid message' do
    context 'when user is nil' do
      let(:conversation) { create(:conversation) }
      let(:message) { build(:message, user: nil, conversation: conversation, body: 'Hello') }

      it 'is invalid without a user' do
        expect(message).not_to be_valid
        expect(message.errors[:user]).to include("must exist")
      end
    end
  end

  context 'when conversation is nil' do
    let(:user) { create(:user) }
    let(:message) { build(:message, user: user, conversation: nil, body: 'Hello') }

    it 'is invalid without a conversation' do
      expect(message).not_to be_valid
      expect(message.errors[:conversation]).to include("must exist")
    end
  end


  context 'when body is nil or empty' do
    let(:user) { create(:user) }
    let(:conversation) { create(:conversation) }
    let(:message) { build(:message, user: user, conversation: conversation, body: nil) }

    it 'is invalid without a body' do
      expect(message).not_to be_valid
      expect(message.errors[:body]).to include("can't be blank")
    end
  end



end
