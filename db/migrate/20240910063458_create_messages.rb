class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :conversation, index: true

      t.references :user, index: true

      t.timestamps
    end
  end
end
