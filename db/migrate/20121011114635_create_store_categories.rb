class CreateStoreCategories < ActiveRecord::Migration
  def change
    create_table :store_categories do |t|
      t.integer :store_id
      t.integer :category_id
      t.timestamps
    end
  end
end
