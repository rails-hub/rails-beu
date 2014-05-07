class Wallet < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :deal

  attr_accessible :deal_id,  :user_id

end
