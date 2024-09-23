class AddRecipientToConversations < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:conversations, :recipient_id)
      add_column :conversations, :recipient_id, :integer
      add_column :conversations, :recipient_type, :string
    end
  end
end
