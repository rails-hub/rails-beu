class AddIsActiveToCreditCardInformations < ActiveRecord::Migration
  def change
    add_column :credit_card_informations, :is_active, :boolean, :default => false
  end
end
