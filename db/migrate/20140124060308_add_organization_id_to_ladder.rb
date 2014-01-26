class AddOrganizationIdToLadder < ActiveRecord::Migration
  def change
    add_column :ladders, :organization_id, :integer
    add_index :ladders, :organization_id
  end
end
