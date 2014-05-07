class CreateDealCompaignObjectives < ActiveRecord::Migration
  def change
    create_table :deal_compaign_objectives do |t|
      t.references :deal
      t.references :compaign_objective
      
      t.timestamps
    end
  end
end
