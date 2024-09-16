class ExternalChat < ApplicationRecord
    has_many :messages
    validates :email, presence: true, uniqueness: true
    has_many :conversations, dependent: :destroy
    has_many :external_members, through: :conversations
    belongs_to :user
    belongs_to :conversation
    belongs_to :external_member
end
