class ExternalChat < ApplicationRecord
    belongs_to :user
    belongs_to :external_member
    belongs_to :conversation
    has_many :messages
    has_many :conversations, dependent: :destroy
    has_many :external_members, through: :conversations
  
    validates :email, presence: true, uniqueness: true
end
