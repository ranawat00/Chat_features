class RemoveExternalChatIdAndExternalMemberIdFromMessages < ActiveRecord::Migration[7.2]
  def change
    remove_column :messages, :external_chat_id, :integer
    remove_column :messages, :external_member_id, :integer
  end
end
