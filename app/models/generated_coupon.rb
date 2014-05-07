class GeneratedCoupon < ActiveRecord::Base
  attr_accessible :coupons_code, :deal_id, :redempetion_code, :user_id
  belongs_to :deal
  belongs_to :user
end
