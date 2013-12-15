class RemoveWinnerNameFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :winner_name, :string
  end
end
