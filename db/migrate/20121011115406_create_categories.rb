class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.string :logo_url
      t.integer :rule_id
      
      t.timestamps
    end
  end
end
