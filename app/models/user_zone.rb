class UserZone < ActiveRecord::Base
  attr_accessible :user_id, :zone_id
  belongs_to :user
  belongs_to :zone, :class_name=>"Admin::Zone"
end
