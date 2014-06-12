class AddDrawColumnToCompetitor < ActiveRecord::Migration
  def change
    add_column :competitors, :draws, :integer, :default => 0
  end
end
