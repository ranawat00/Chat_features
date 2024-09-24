class RemoveForeignKeyFromConversations < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :conversations, :external_members, column: :external_member_id
  rescue ActiveRecord::StatementInvalid
    
  end
end
