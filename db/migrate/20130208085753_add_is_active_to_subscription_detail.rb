class AddIsActiveToSubscriptionDetail < ActiveRecord::Migration
  def change
    add_column :subscription_details, :is_active, :boolean, :default=>false
  end
end
