class AddExternalMemberToMessages < ActiveRecord::Migration[7.2]
  def change
    add_reference :messages, :external_member, foreign_key: true, null: true 
  end 
end
