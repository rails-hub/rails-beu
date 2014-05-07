class DealsViewUser < ActiveRecord::Base
  belongs_to :deal
  belongs_to :user
   attr_accessible :user_id, :deal_id
end
