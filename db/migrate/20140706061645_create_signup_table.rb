class CreateSignupTable < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.string :email
    end
  end
end
