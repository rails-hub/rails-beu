class TempUser < ActiveRecord::Base

    attr_accessible :retailer_image, :session_id
  
    has_attached_file :retailer_image, :styles => { :thumb => "100x100>" }
end
