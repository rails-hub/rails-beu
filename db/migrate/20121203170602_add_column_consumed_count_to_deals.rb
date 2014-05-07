class AddColumnConsumedCountToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :consumed_count, :integer, :default => 0
  end
end
