class Admin::Classified < ActiveRecord::Base
  attr_accessible :classified_category_id, :isactive, :name
  belongs_to :classified_category

end
