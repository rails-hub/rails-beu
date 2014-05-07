class RemoveColumnRedemptFromWallets < ActiveRecord::Migration
  def up
    remove_column :wallets, :redempt
  end

  def down
    add_column :wallets, :redempt, :boolean
  end
end
