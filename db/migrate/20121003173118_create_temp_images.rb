class CreateTempImages < ActiveRecord::Migration
  def change
    create_table :temp_images do |t|
      t.attachment :logo_image
      t.attachment :retail_image
      t.attachment :thing_image
      t.string :session_id
      t.references :deal
      t.timestamps
    end
  end
end
