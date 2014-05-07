class CreateUserZones < ActiveRecord::Migration
  def change
    create_table :user_zones do |t|
      t.integer :user_id
      t.integer :zone_id

      t.timestamps
    end
  end
end
