class AddMatchIdtoGames < ActiveRecord::Migration
  def change
    add_column :games, :match_id, :integer
    add_index :games, :match_id
  end
end
