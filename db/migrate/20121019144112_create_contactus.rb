class CreateContactus < ActiveRecord::Migration
  def change
    create_table :contactus do |t|
      t.string :name
      t.string :company
      t.string :email
      t.string :phone
      t.string :message

      t.timestamps
    end
  end
end
