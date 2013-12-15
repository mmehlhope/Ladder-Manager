class AddLadderIDtoCompetitor < ActiveRecord::Migration
  def change
    add_column :competitors, :ladder_id, :integer 
    add_index :competitors, :ladder_id 
  end
end
