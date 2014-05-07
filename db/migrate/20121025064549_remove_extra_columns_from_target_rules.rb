class RemoveExtraColumnsFromTargetRules < ActiveRecord::Migration
  def up
    remove_column :target_rules, :all_age
    remove_column :target_rules, :gender
    remove_column :target_rules, :birthday
    remove_column :target_rules, :past_customer
    remove_column :target_rules, :age_to
    remove_column :target_rules, :age_from
    
  end

  def down
    add_column :target_rules, :all_age, :boolean
    add_column :target_rules, :gender, :boolean
    add_column :target_rules, :birthday, :string
    add_column :target_rules, :past_customer, :boolean
    add_column :target_rules, :age_to, :string
    add_column :target_rules, :age_from, :string
  end
end
