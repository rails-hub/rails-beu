class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :title
      t.float :price
      t.integer :duration
      t.datetime :expiry
      t.string :compaigns_per_month
      t.timestamps
    end
  end
end
