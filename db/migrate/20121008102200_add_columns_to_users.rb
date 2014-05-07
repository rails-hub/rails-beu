class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :business_name, :string
    add_column :users, :administrator, :string
    add_column :users, :address, :string
    add_column :users, :phone, :string
  end
end
