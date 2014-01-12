class RemoveAccountInfoFromLadder < ActiveRecord::Migration
  def change
    remove_column :ladders, :admin_email
    remove_column :ladders, :password_digest
  end
end
