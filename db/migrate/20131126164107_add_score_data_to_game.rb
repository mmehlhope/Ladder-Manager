class AddScoreDataToGame < ActiveRecord::Migration
  def change
    add_column :games, :competitor_1_score, :integer
    add_column :games, :competitor_2_score, :integer
  end
end
