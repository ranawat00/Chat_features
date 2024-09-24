class AddForeignKeyToConversationsForExternalMember < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :conversations, :external_members, column: :external_member_id
  end
end
