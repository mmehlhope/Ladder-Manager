class AddPasswordAndEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :text
    add_column :users, :email, :string
    remove_column :users, :password
  end
end
