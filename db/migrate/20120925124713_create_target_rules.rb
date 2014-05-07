class CreateTargetRules < ActiveRecord::Migration
  def change
    create_table :target_rules do |t|
      t.string :title
      t.boolean :all
      t.string :age_category
      t.boolean :gender
      t.string :birthday
      t.boolean :past_customer
      t.string :start_date
      t.string :end_date
      t.references :deal

      t.timestamps
    end
    add_index :target_rules, :deal_id
  end
end
