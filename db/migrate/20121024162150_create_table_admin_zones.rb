class CreateTableAdminZones < ActiveRecord::Migration
  def change
    create_table :admin_zones do |t|
      t.string :name
      t.boolean :isactive

      t.timestamps
    end
  end
end
