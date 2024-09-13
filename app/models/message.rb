class Message < ApplicationRecord
    belongs_to :conversation
    belongs_to :user
    validates :user, presence: true
    validates :body, presence: true
    # belongs_to :external_chat
end
