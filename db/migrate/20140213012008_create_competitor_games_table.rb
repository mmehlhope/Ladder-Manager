class CreateCompetitorGamesTable < ActiveRecord::Migration
  def change
    create_table :competitors_games, :id => false do |t|
      t.references :game
      t.references :competitor
    end
  end
end

