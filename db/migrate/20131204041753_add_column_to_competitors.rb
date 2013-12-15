class AddColumnToCompetitors < ActiveRecord::Migration
  def change
    add_column :competitors, :match_id, :integer
  end
end
