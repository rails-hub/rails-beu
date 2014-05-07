class AddColumnGiftOrSeasonalItemToDeals < ActiveRecord::Migration
  def up
    add_column :deals, :gift_or_seasonal_item, :boolean
  end
  def down
    remove_column :deals, :gift_or_seasonal_item
  end
end
