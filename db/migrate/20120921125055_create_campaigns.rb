class CreateCampaigns < ActiveRecord::Migration
  def up
    create_table :campaigns do |t|
      t.string :name
      t.references :location

      t.timestamps
    end
    add_index :campaigns, :location_id
  end

  def down
    drop_table :campaigns
  end
end
