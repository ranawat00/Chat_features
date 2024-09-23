# spec/models/external_member_spec.rb

require 'rails_helper'

RSpec.describe ExternalMember, type: :model do
  let!(:external_member) { build(:external_member) }

  describe 'associations' do
    # it { should have_many(:messages) }
    it { should have_many(:conversations).dependent(:destroy) }
    # it { should have_many(:external_chats).through(:conversations) }
    it { should have_many(:invitations).dependent(:destroy) }
  end

  describe 'validations' do
    it 'validates presence of email' do
      external_member.email = nil
      expect(external_member).not_to be_valid
      expect(external_member.errors[:email]).to include("can't be blank")
    end

    it 'validates format of email' do
      external_member.email = 'invalid_email'
      expect(external_member).not_to be_valid
      expect(external_member.errors[:email]).to include("is invalid")
    end

    # it 'validates uniqueness of email' do
    #   create(:external_member, email: 'unique@example.com')
    #   external_member.email = 'unique@example.com'
    #   expect(external_member).not_to be_valid
    #   expect(external_member.errors[:email]).to include("has already been taken")
    # end
  end

  describe 'valid external member creation' do
    it 'is valid with valid attributes' do
      external_member.email = 'valid@example.com'
      expect(external_member).to be_valid
    end
  end
end
