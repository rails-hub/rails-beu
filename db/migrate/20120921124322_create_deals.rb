class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :title
      t.string :description
      t.string :retailer_logo
      t.string :image
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
