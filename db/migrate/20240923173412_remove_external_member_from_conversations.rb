class RemoveExternalMemberFromConversations < ActiveRecord::Migration[7.2]
  def change
    remove_column :conversations, :external_member, :string
  end
end
