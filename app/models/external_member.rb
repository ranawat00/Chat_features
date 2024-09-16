class ExternalMember < ApplicationRecord
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }
    has_many :messages
    has_many :conversations, dependent: :destroy
    has_many :external_chats, through: :conversations
    has_many :invitations, dependent: :destroy
end
