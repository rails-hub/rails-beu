class Admin::Zone < ActiveRecord::Base
  attr_accessible :isactive, :name
  validates :name,:presence => true
   has_many :hotspots, :class_name => 'Admin::Hotspot', :foreign_key => :zone_id
end
