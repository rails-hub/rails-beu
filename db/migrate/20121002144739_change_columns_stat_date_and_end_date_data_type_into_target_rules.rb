class ChangeColumnsStatDateAndEndDateDataTypeIntoTargetRules < ActiveRecord::Migration
  def up
    remove_column :target_rules, :start_date
    remove_column :target_rules, :end_date
    add_column :target_rules, :start_date, :datetime
    add_column :target_rules, :end_date, :datetime
  end

  def down
    remove_column :target_rules, :start_date
    remove_column :target_rules, :end_date
    add_column :target_rules, :start_date, :string
    add_column :target_rules, :end_date, :string
  end
end
