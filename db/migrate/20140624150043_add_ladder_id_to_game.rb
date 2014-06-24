class AddLadderIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :ladder_id, :integer
  end
end
