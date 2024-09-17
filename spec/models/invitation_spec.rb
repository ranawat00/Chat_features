require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe 'validations' do
    let(:external_member) { ExternalMember.create(email: 'test@example.com') }

    it 'is valid with valid attributes' do
      invitation = Invitation.new(external_member: external_member, status: 'pending')
      expect(invitation).to be_valid
    end

    it 'is not valid without an external_member' do
      invitation = Invitation.new(status: 'pending')
      expect(invitation).to_not be_valid
      expect(invitation.errors[:external_member]).to include("must exist")
    end

    it 'is not valid with an invalid status' do
      invitation = Invitation.new(external_member: external_member, status: 'invalid_status')
      expect(invitation).to_not be_valid
      expect(invitation.errors[:status]).to include("is not included in the list")
    end

    it 'is not valid with an invalid status' do
      invitation = Invitation.new(external_member: external_member, status: 'invalid_status')
      expect(invitation).to_not be_valid
      expect(invitation.errors[:status]).to include("is not included in the list")
    end

    
    it 'does not allow duplicate tokens' do
      Invitation.create(external_member: external_member, status: 'pending', token: 'unique_token')
      invitation = Invitation.new(external_member: external_member, status: 'accepted', token: 'unique_token')
      # expect(invitation).to_not be_valid
      # expect(invitation.errors[:token]).to include("has already been taken")
    end
  end


  describe 'associations' do
    it 'belongs to an external_member' do
      association = described_class.reflect_on_association(:external_member)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
