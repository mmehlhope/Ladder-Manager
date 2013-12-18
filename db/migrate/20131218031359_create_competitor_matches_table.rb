class CreateCompetitorMatchesTable < ActiveRecord::Migration
  def change
    create_table :competitors_matches, :id => false do |t|
      t.references :match
      t.references :competitor
    end
    add_index :competitors_matches, [:match_id, :competitor_id]
    add_index :competitors_matches, :competitor_id
  end
end
