class AddFinalizeBooleanToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :finalized, :boolean, :default => false
  end
end
