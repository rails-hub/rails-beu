class DealsWizard < ActiveRecord::Base

  #relations with tables
  has_many :deal_compaign_objectives, :dependent => :destroy
  has_many :compaign_objectives, :through => :deal_compaign_objectives
  belongs_to :deal
  #attr_accessibles
  attr_accessible :buy_offer, :buy_units, :fixed_offer, :spend_amount, :spend_offer, :buy, :spend, :deal_id, :compaign_objectives_ids

  #attr_accessors
  attr_accessor :compaign_objectives_ids

  #validations
  validates :buy_units, :presence => true, :if => :buy?
  validates :buy_units, :numericality => { :only_integer => true , :greater_than=> 0 ,
   :message => "must be integer and greater than 0" }, :if => :buy?

  validates :spend_amount, :presence => true, :if => :spend?
  validates :spend_amount, :numericality => { :only_integer => true , :greater_than=> 0 ,
   :message => "must be integer and greater than 0" }, :if => :spend?

  validates :buy_offer, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}, :if => :buy?
  validates :spend_offer, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}, :if => :spend?
  #callbacks
  
  after_save do  |deal_wizard|
    deal_wizard.deal_compaign_objectives.each do |objective|
      objective.destroy
    end
    
    compaign_objectives_ids = deal_wizard.compaign_objectives_ids.split(',')
    compaign_objectives_ids.each do |objective_id|
      next if objective_id.blank? or deal_wizard.id.blank?
      params_hash = {:deals_wizard_id=>deal_wizard.id, :compaign_objective_id=>objective_id}
      DealCompaignObjective.create(params_hash)
    end
  end
end
