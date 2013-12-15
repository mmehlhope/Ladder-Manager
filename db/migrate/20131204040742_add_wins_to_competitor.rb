class AddWinsToCompetitor < ActiveRecord::Migration
  def change
    add_column :competitors, :wins, :integer
  end
end
