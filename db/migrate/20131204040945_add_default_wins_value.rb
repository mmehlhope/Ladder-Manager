class AddDefaultWinsValue < ActiveRecord::Migration
  def change
    change_column :competitors, :wins, :integer, :default => 0
  end
end
