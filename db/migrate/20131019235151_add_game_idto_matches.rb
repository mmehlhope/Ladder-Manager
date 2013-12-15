class AddGameIdtoMatches < ActiveRecord::Migration
  def change
    add_column :matches, :game_id, :integer
    add_index :matches, :game_id
  end
end
