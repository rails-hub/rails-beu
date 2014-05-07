class AddColumnsToTargetRules < ActiveRecord::Migration
  def up
    add_column :target_rules, :age_12_17, :boolean
    add_column :target_rules, :age_18_25, :boolean
    add_column :target_rules, :age_36_44, :boolean
    add_column :target_rules, :age_45_and_older, :boolean
    add_column :target_rules, :male, :boolean
    add_column :target_rules, :female, :boolean
    add_column :target_rules, :today, :boolean
    add_column :target_rules, :this_week, :boolean
    add_column :target_rules, :within_30_days, :boolean
    add_column :target_rules, :is_pastcustomer, :boolean
    add_column :target_rules, :not_pastcustomer, :boolean
    add_column :target_rules, :all, :boolean

  end
  
  def down
    remove_column :target_rules, :age_12_17
    remove_column :target_rules, :age_18_25
    remove_column :target_rules, :age_36_44
    remove_column :target_rules, :age_45_and_older
    remove_column :target_rules, :male
    remove_column :target_rules, :female
    remove_column :target_rules, :today
    remove_column :target_rules, :this_week
    remove_column :target_rules, :within_30_days
    remove_column :target_rules, :is_pastcustomer
    remove_column :target_rules, :not_pastcustomer
    remove_column :target_rules, :all
  end
end
