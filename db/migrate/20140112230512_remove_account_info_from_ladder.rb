class RemoveAccountInfoFromLadder < ActiveRecord::Migration
  def change
    remove_column :ladders, :admin_email
  end
end
