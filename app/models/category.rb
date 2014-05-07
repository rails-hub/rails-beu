class Category < ActiveRecord::Base
   attr_accessible :description, :logo_url, :name, :target_rule_id

  belongs_to :target_rule
  has_many :stores, :through => :store_categories
  has_many :user_categories
  has_many :users, :through => :user_categories

def self.get_categories(user_id)
  self.
    select('categories.id').select('categories.name').select('categories.description ').select('categories.logo_url').
    joins("LEFT OUTER JOIN user_categories ON user_categories.category_id = categories.id AND user_categories.user_id = #{user_id}")
end
end
