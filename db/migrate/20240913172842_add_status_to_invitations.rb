class AddStatusToInvitations < ActiveRecord::Migration[7.2]
  def change
    add_column :invitations, :status, :string,default: 'pending'
  end
end
