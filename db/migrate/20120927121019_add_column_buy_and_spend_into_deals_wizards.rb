class AddColumnBuyAndSpendIntoDealsWizards < ActiveRecord::Migration
  def self.up
    add_column :deals_wizards, :buy, :boolean
    add_column :deals_wizards, :spend, :boolean
  end

  def self.down
    remove_column :deals_wizards, :buy
    remove_column :deals_wizards, :spend
  end
end
