class AddCompetitorsToLadder < ActiveRecord::Migration
  def change
    add_column :ladders, :competitor_id, :integer
    add_index :ladders, :competitor_id
  end
end
