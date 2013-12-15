class RemoveCompetitorIdAndMatchIdFromLadders < ActiveRecord::Migration
  def change
    remove_column :ladders, :competitor_id, :integer
    remove_column :ladders, :match_id, :integer
  end
end
