class RedeemedDeal < ActiveRecord::Base
  attr_accessible :deal_id, :user_id, :redemption_code, :coupon_code
  belongs_to :deal
  belongs_to :user
end
