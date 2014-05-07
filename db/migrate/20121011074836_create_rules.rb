class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name
      t.boolean :all_age
      t.integer :age_from
      t.integer :age_to
      t.string :gender
      t.timestamps
    end
  end
end
