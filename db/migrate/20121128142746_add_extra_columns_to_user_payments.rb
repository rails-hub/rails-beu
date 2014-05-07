class AddExtraColumnsToUserPayments < ActiveRecord::Migration
  def up
    
    add_column :user_payments, :month_number, :integer
    add_column :user_payments, :start_date, :datetime
    add_column :user_payments, :end_date, :datetime
    add_column :user_payments, :allowed_campaigns, :integer
    add_column :user_payments, :consumed_campaigns, :integer
    add_column :user_payments, :plan_id, :integer
    add_column :user_payments, :plan_type, :string
  end
  
  def down

    remove_column :user_payments, :month_number
    remove_column :user_payments, :start_date
    remove_column :user_payments, :end_date
    remove_column :user_payments, :allowed_campaigns
    remove_column :user_payments, :consumed_campaigns
    remove_column :user_payments, :plan_id
    remove_column :user_payments, :plan_type
  end
end
