class CreateUserPayments < ActiveRecord::Migration
  def change
    create_table :user_payments do |t|
      t.string :status
      t.float :amount
      t.integer :user_id

      t.timestamps
    end
  end
end
