class ExternalChat < ApplicationRecord
    has_many :messages
    validates :email, presence: true, uniqueness: true
    has_many :conversations, dependent: :destroy
    has_many :external_members, through: :conversations
end
