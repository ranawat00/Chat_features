class ChangeRecipientIdInConversations < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :conversations, :users, column: :recipient_id if !column_exists?(:conversations, :recipient_id)

  end
end
