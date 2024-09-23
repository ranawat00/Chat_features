class AddExternalMemberToConversations < ActiveRecord::Migration[7.2]
  def change
    add_reference :conversations, :external_member,  foreign_key: true
  end
end
