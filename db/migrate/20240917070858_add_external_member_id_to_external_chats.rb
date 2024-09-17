class AddExternalMemberIdToExternalChats < ActiveRecord::Migration[7.2]
  def change
    add_column :external_chats, :external_member_id, :integer
  end
end
