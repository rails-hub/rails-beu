class CompaignObjective < ActiveRecord::Base
 attr_accessible :name
  has_many :deal_compaign_objectives, :dependent => :destroy
  has_many :deals_wizards, :through => :deal_compaign_objectives
end
