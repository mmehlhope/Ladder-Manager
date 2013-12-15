class CreateLadders < ActiveRecord::Migration
  def change
    create_table :ladders do |t|
      t.string :name

      t.timestamps
    end
  end
end
