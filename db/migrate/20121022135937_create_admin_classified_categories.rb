class CreateAdminClassifiedCategories < ActiveRecord::Migration
  def change
    create_table :admin_classified_categories do |t|
      t.string :name
      t.integer :parent_category_id

      t.timestamps
    end
  end
end
