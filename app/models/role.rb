class Role < ActiveRecord::Base
  attr_accessible :name

  has_many :users

  
  ADMIN_USER_ID = 1
  SITE_USER_ID =2
  END_USER_ID = 3
end
