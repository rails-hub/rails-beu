class Plan < ActiveRecord::Base
  attr_accessible :duration, :expiry, :price, :title,:compaigns_per_month, :plan_type
  has_many :subscription_details

  def get_amount
    self.price*100
  end

end
