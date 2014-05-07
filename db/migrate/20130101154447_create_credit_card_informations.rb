class CreateCreditCardInformations < ActiveRecord::Migration
  def change
    create_table :credit_card_informations do |t|
      t.string :first_name
      t.string :last_name
      t.string :card_number
      t.string :verification_code
      t.datetime :expiry_date
      t.references :user
      t.string :response

      t.timestamps
    end
    add_index :credit_card_informations, :user_id
  end
end
