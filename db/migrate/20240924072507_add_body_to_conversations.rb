class AddBodyToConversations < ActiveRecord::Migration[7.2]
  def change
    add_column :conversations, :body, :text
  end
end
