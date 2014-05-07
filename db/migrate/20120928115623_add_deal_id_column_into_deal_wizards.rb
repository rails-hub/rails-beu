class AddDealIdColumnIntoDealWizards < ActiveRecord::Migration
  def up
    add_column :deals_wizards, :deal_id, :int
  end

  def down
    remove_column :deals_wizards, :deal_id
  end
end
