class CreateAdminHotspots < ActiveRecord::Migration
  def change
    create_table :admin_hotspots do |t|
      t.string :name
      t.string :address
      t.integer :zone_id

      t.timestamps
    end
  end
end
