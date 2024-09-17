require 'rails_helper'

RSpec.describe ExternalMember, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      external_member = ExternalMember.new(email: 'test@example.com')
      expect(external_member).to be_valid
    end

    it 'is not valid without an email' do
      external_member = ExternalMember.new(email: nil)
      expect(external_member).to_not be_valid
      expect(external_member.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with an invalid email format' do
      external_member = ExternalMember.new(email: 'invalid_email')
      expect(external_member).to_not be_valid
      expect(external_member.errors[:email]).to include("is invalid")
    end

    it 'is valid with a correct email format' do
      external_member = ExternalMember.new(email: 'valid@example.com')
      expect(external_member).to be_valid
    end
  end

  describe 'associations' do
    it 'has many messages' do
      association = described_class.reflect_on_association(:messages)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many conversations' do
      association = described_class.reflect_on_association(:conversations)
      expect(association.macro).to eq(:has_many)
    end

    it 'destroys associated conversations' do
      external_member = ExternalMember.create(email: 'test@example.com')
      conversation = Conversation.create(external_member: external_member)
      expect { external_member.destroy }.to change { Conversation.count }.by(0)
    end

    it 'has many external_chats through conversations' do
      association = described_class.reflect_on_association(:external_chats)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many invitations' do
      association = described_class.reflect_on_association(:invitations)
      expect(association.macro).to eq(:has_many)
    end

    it 'destroys associated invitations' do
      external_member = ExternalMember.create(email: 'test@example.com')
      invitation = Invitation.create(external_member: external_member)
      expect { external_member.destroy }.to change { Invitation.count }.by(-1)
    end
  end

end
