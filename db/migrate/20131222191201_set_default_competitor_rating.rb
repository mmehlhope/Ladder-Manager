class SetDefaultCompetitorRating < ActiveRecord::Migration
  def change
    change_column :competitors, :rating, :integer, :default => 1000
  end
end
