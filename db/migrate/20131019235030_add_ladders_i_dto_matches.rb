class AddLaddersIDtoMatches < ActiveRecord::Migration
  def change
    add_column :matches, :ladder_id, :integer
    add_index :matches, :ladder_id
  end
end
