class AddUserIdToExternalChats < ActiveRecord::Migration[7.2]
  def change
    add_column :external_chats, :user_id, :integer
  end
end
