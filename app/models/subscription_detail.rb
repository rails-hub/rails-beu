class SubscriptionDetail < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user
  attr_accessible :balance_due, :expiry, :status, :plan_id, :user_id, :service_type, :is_active, :full_name
  scope :active, where(:is_active=>true)
end
