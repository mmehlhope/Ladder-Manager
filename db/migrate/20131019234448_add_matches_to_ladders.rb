class AddMatchesToLadders < ActiveRecord::Migration
  def change
    add_column :ladders, :match_id, :integer
    add_index :ladders, :match_id
  end
end
