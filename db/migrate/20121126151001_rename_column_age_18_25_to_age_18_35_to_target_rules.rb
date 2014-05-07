class RenameColumnAge1825ToAge1835ToTargetRules < ActiveRecord::Migration
  def up
	rename_column :target_rules, :age_18_25, :age_18_35
  end

  def down
	rename_column :target_rules, :age_18_35, :age_18_25
  end
end
