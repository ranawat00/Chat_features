

require 'rails_helper'

RSpec.describe ExternalChat, type: :model do
  let!(:user) { create(:user) }
  let!(:external_member) { create(:external_member) } 
  let!(:recipient) { create(:user) }

  
  let!(:conversation) { create(:conversation, sender: user, recipient: user) }

  let!(:external_chat) { build(:external_chat, user: user, external_member: external_member, conversation: conversation) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:external_member) }
    it { should belong_to(:conversation) }
    # it { should have_many(:messages) }
    # it { should have_many(:conversations).dependent(:destroy) }
    it { should have_many(:external_members).through(:conversations) }
  end

  describe 'validations' do
    it 'validates presence of email' do
      external_chat.email = nil
      expect(external_chat).not_to be_valid
      expect(external_chat.errors[:email]).to include("can't be blank")
    end
  end

  describe 'valid external chat creation' do
    it 'is valid with valid attributes' do
      external_chat.email = 'valid@example.com'
      expect(external_chat).to be_valid
    end
  end
end
