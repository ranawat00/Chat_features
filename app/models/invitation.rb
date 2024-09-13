class Invitation < ApplicationRecord
  
  belongs_to :external_member
  # before_create :generate_token

  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create 
  validates :status, inclusion: { in: %w[pending accepted rejected] }
  # validates :status, inclusion: { in: %w[pending accepted rejected] }

  private

  def generate_token
    self.token = SecureRandom.hex(10) # Generates a unique token
  end
end
