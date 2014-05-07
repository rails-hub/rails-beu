class AddColumnRedemptionCodeAndCouponCodeToRedeemedDeals < ActiveRecord::Migration
  def up
    add_column :redeemed_deals, :coupon_code, :string
    add_column :redeemed_deals, :redemption_code, :string
  end

  def down
    remove_column :redeemed_deals, :coupon_code
    remove_column :redeemed_deals, :redemption_code
  end
end
