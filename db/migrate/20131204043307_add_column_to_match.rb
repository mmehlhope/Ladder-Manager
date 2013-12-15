class AddColumnToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :history_id, :integer
    add_column :matches, :history_type, :string
  end
end
