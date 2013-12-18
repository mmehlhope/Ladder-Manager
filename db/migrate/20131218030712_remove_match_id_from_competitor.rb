class RemoveMatchIdFromCompetitor < ActiveRecord::Migration
  def change
    remove_column :competitors, :match_id
  end
end
