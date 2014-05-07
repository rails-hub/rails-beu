class UserCategory < ActiveRecord::Base
  attr_accessible :category_id, :user_id

  belongs_to :user
  belongs_to :category

  alias_attribute :user_category, :user_id

  def as_json(options={})
    options[:methods] = [:user_category]
    options[:only] = [:user_category]
    super
    
  end
end
