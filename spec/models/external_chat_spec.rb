require 'rails_helper'

RSpec.describe ExternalChat, type: :model do

  it { should have_many(:messages) }
  it { should have_many(:conversations).dependent(:destroy) }
  it { should have_many(:external_members).through(:conversations) }
  it { should have_many(:messages) }
  it { should have_many(:external_members).through(:conversations) }
  it { should validate_presence_of(:email) }

  it 'validates uniqueness of email' do
    existing_chat = create(:external_chat, email: 'unique@example.com')
    new_chat = build(:external_chat, email: 'unique@example.com')
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
    chat = create(:external_chat)
    conversation = create(:conversation, external_chat: chat, external_member: external_member)
    chat.destroy
    expect(Conversation.exists?(conversation.id)).to be_falsey
  end

  it 'has a valid factory' do
    expect(build(:external_chat)).to be_valid
  end  

end