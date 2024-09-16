class Conversation < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name:'User'
  has_many :messages
  has_many :external_chats
  has_many :users, through: :messages
  belongs_to :external_chat
  belongs_to :external_member
  validates :external_chat, presence: true
  validates :external_member, presence: true
  
  # Additional validations and scopes
  validates_uniqueness_of :external_chat_id, scope: :external_member_id
  validates_uniqueness_of :sender_id, scope: :recipient_id
  scope :between, -> (sender_id, recipient_id) do 
  where("(conversations.sender_id = ? AND   conversations.recipient_id =?) OR (conversations.sender_id = ? 
  AND conversations.recipient_id =?)", sender_id, recipient_id, recipient_id, sender_id)
  end
end
