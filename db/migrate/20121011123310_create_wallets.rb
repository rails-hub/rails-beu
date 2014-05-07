class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.integer :user_id
      t.integer :deal_id
      t.boolean :redempt
      
      t.timestamps
    end
  end
end
