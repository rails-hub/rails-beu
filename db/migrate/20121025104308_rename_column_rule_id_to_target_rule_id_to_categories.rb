class RenameColumnRuleIdToTargetRuleIdToCategories < ActiveRecord::Migration
  def up
    rename_column :categories, :rule_id, :target_rule_id
  end

  def down
    rename_column :categories, :target_rule_id, :rule_id
  end
end
