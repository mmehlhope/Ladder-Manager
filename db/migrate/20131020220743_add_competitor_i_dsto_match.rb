class AddCompetitorIDstoMatch < ActiveRecord::Migration
  def change
    add_column :matches, :competitor_1, :integer
    add_column :matches, :competitor_2, :integer
    add_index :matches, :competitor_1
    add_index :matches, :competitor_2
  end
end
