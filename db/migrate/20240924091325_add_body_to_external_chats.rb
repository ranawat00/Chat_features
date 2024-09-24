class AddBodyToExternalChats < ActiveRecord::Migration[7.2]
  def change
    add_column :external_chats, :body, :text
  end
end
