class RemoveColumnFromMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :game_id
  end
end
