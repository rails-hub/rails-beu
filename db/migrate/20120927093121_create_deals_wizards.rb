class CreateDealsWizards < ActiveRecord::Migration
  def change
    create_table :deals_wizards do |t|
      t.boolean :fixed_offer
      t.integer :buy_units
      t.float :buy_offer
      t.integer :spend_amount
      t.float :spend_offer

      t.timestamps
    end
  end
end
