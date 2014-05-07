class AddColumnRedemptionCodeToStores < ActiveRecord::Migration
  def change
    add_column :stores, :redemption_code, :string
  end
end
