class AddRatingToCompetitor < ActiveRecord::Migration
  def change
    add_column :competitors, :rating, :integer
  end
end
