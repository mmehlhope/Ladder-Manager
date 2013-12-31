class AddPasswordDigestToLadder < ActiveRecord::Migration
  def change
    add_column :ladders, :password_digest, :text
  end
end
