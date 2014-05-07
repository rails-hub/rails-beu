class AddAgeFromAgeToRemoveAgeCategoryAndRenameAllToAllAgeTitleToNamToTargeToTargetRules < ActiveRecord::Migration
  def up
    add_column :target_rules, :age_to, :string
    add_column :target_rules, :age_from, :string
    rename_column :target_rules, :all, :all_age
    rename_column :target_rules, :title, :name
    remove_column :target_rules, :age_category
  end
  
  def down
    remove_column :target_rules, :age_to
    remove_column :target_rules, :age_from
    rename_column :target_rules, :all_age, :all
    rename_column :target_rules, :name, :title
    add_column :target_rules, :age_category, :string
  end
end
