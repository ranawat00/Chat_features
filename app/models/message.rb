class Message < ApplicationRecord
    belongs_to :conversation
    belongs_to :user
    belongs_to :external_member
    validates :user, presence: true
    validates :body, presence: true
    validates :conversation, presence: true
end
