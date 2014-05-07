class CreateRedeemedDeals < ActiveRecord::Migration
  def change
    create_table :redeemed_deals do |t|
      t.integer :user_id
      t.integer :deal_id

      t.timestamps
    end
  end
end
