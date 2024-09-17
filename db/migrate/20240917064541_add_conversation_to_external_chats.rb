class AddConversationToExternalChats < ActiveRecord::Migration[7.2]
  def change
    add_reference :external_chats, :conversation, null: false, foreign_key: true
  end
end
