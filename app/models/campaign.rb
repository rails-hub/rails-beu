class Campaign < ActiveRecord::Base
  belongs_to :location
  attr_accessible :name
end
