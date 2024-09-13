class CreateExternalChats < ActiveRecord::Migration[7.2]
  def change
    create_table :external_chats do |t|
      t.string :email, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
