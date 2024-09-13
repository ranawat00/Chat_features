class CreateExternalMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :external_members do |t|
        t.string "email", null: false
        t.string "name"
      t.timestamps
    end
  end
end
