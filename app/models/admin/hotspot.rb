class Admin::Hotspot < ActiveRecord::Base
  attr_accessible :address, :name, :zone_id,:called_by
  attr_accessor :called_by
  belongs_to :zone, :class_name => 'Admin::Zone'
   
end
