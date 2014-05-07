class CreateSubscriptionDetails < ActiveRecord::Migration
  def change
    create_table :subscription_details do |t|
      t.references :plan
      t.references :user
      t.string :status
      t.datetime :expiry
      t.float :balance_due
      t.string :service_type
      t.timestamps
    end
    add_index :subscription_details, :plan_id
    add_index :subscription_details, :user_id
  end
end
