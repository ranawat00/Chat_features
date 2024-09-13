class AddExternalchatToMessages < ActiveRecord::Migration[7.2]
  def change
    add_reference :messages, :external_chat, foreign_key: true, null: true
  end
end
