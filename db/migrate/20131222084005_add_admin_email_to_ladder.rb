class AddAdminEmailToLadder < ActiveRecord::Migration
  def change
    add_column :ladders, :admin_email, :string
  end
end
