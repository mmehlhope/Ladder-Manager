class RemoveHistoryFromMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :history_id
    remove_column :matches, :history_type
  end
end
