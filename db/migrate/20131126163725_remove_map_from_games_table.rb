class RemoveMapFromGamesTable < ActiveRecord::Migration
  def change
    remove_column :games, :map
  end
end
