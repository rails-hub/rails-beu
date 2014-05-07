class CreateAdminClassifieds < ActiveRecord::Migration
  def change
    create_table :admin_classifieds do |t|
      t.string :name
      t.integer :classified_category_id
      t.boolean :isactive

      t.timestamps
    end
  end
end
