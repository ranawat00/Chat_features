class RemoveExternalFieldsFromConversations < ActiveRecord::Migration[7.2]
  def change
    remove_column :conversations, :external_chat_id, :integer
    remove_column :conversations, :external_member_id, :integer
  end
end
