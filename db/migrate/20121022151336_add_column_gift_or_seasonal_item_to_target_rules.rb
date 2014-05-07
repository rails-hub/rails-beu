class AddColumnGiftOrSeasonalItemToTargetRules < ActiveRecord::Migration
  def change
    add_column :target_rules, :gift_or_seasonal_item, :boolean
  end
end
