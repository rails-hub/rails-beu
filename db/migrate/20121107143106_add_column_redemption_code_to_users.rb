class AddColumnRedemptionCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :redemption_code, :string
  end
end
