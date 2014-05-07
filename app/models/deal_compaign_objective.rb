class DealCompaignObjective < ActiveRecord::Base
  
  
  belongs_to :compaign_objective
  belongs_to :deals_wizard
  
  attr_accessible :deals_wizard_id, :compaign_objective_id


end
