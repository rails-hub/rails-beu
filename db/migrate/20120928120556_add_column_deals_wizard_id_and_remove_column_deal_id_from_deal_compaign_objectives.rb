class AddColumnDealsWizardIdAndRemoveColumnDealIdFromDealCompaignObjectives < ActiveRecord::Migration
  def up
    add_column :deal_compaign_objectives, :deals_wizard_id, :int
    remove_column :deal_compaign_objectives, :deal_id
  end

  def down
    add_column :deal_compaign_objectives, :deal_id, :int
    remove_column :deal_compaign_objectives, :deals_wizard_id
  end
end
