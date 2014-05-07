class CreateDealsViewUsers < ActiveRecord::Migration
  def change
    create_table :deals_view_users do |t|
      t.references :deal
      t.references :user

      t.timestamps
    end
    add_index :deals_view_users, :deal_id
    add_index :deals_view_users, :user_id
  end
end
