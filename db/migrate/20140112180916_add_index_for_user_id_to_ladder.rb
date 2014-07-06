class AddIndexForUserIdToLadder < ActiveRecord::Migration
  def change
    add_column :ladders, :user_id, :integer
    add_index :ladders, :user_id
  end
end
