class AddExternalChatAndExternalMemberToConversations < ActiveRecord::Migration[7.2]
  def change
    add_reference :conversations, :external_chat, null: true, foreign_key: true
    add_reference :conversations, :external_member, null: true, foreign_key: true
  end
end
