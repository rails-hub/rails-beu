class Admin::ClassifiedCategory < ActiveRecord::Base
  attr_accessible :name, :parent_category_id


  has_many :subcategories, :class_name => 'Admin::ClassifiedCategory',
    :foreign_key => :parent_category_id
  belongs_to :parent_category, :class_name => 'Admin::ClassifiedCategory'
  has_one :classified
end
