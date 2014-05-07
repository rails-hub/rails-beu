class RenameColumnRuleIdToTargetRuleIdToStores < ActiveRecord::Migration
  def up
    rename_column :stores, :rule_id, :target_rule_id
  end

  def down
    rename_column :stores, :target_rule_id, :rule_id
  end
end
