class ExternalMember < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    has_many :messages, dependent: :destroy
    has_many :conversations, dependent: :destroy
    has_many :external_chats, through: :conversations
    has_many :invitations, dependent: :destroy
end
