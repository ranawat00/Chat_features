require 'rails_helper'

RSpec.describe ExternalChat, type: :model do

  it { should have_many(:messages) }
  it { should have_many(:conversations).dependent(:destroy) }
  it { should have_many(:external_members).through(:conversations) }
  it { should have_many(:messages) }
  # it { should have_many(:external_members).through(:conversations) }
  it { should validate_presence_of(:email) }

  it 'validates uniqueness of email' do
    external_member = create(:external_member)
    conversation = create(:conversation, external_member: external_member)
    user = create(:user)
  
    existing_chat = create(:external_chat, email: 'unique@example.com', user: user, external_member: external_member, conversation: conversation)
    new_chat = build(:external_chat, email: 'unique@example.com', user: user, external_member: external_member, conversation: conversation)
  
    expect(new_chat).not_to be_valid
    expect(new_chat.errors[:email]).to include('has already been taken')
  end

  it 'is invalid without an email' do
    chat = build(:external_chat, email: nil)
    expect(chat).not_to be_valid
    expect(chat.errors[:email]).to include("can't be blank")
  end

  it 'destroys associated conversations when deleted' do
    external_member = create(:external_member)
    conversation = create(:conversation, external_member: external_member)
    chat = create(:external_chat, external_member: external_member, conversation: conversation)
    
    chat.destroy
    # expect(Conversation.exists?(conversation.id)).to be_falsey
  end

  it 'has a valid factory' do
    external_member = create(:external_member)
    conversation = create(:conversation, external_member: external_member)
    user = create(:user)
    expect(build(:external_chat, user: user, external_member: external_member, conversation: conversation)).to be_valid
  end 

end