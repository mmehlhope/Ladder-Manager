class AddWinnerDataToGame < ActiveRecord::Migration
  def change
    add_column :games, :winner_name, :string
    add_column :games, :winner_id, :integer
  end
end
