class AddRemoveAndRenameSomeColumnsInUsers < ActiveRecord::Migration
 def up
    add_column :users, :dob, :datetime
    add_column :users, :gender, :string
    add_column :users, :udid, :string
    add_column :users, :device_type, :string
    add_column :users, :notification_key, :string
    add_column :users, :token_key, :string
    rename_column :users, :phone, :mobile
    rename_column :users, :first_name, :name
    remove_column :users, :last_name
  end
  
  def down
    remove_column :users, :dob
    remove_column :users, :gender
    remove_column :users, :udid
    remove_column :users, :device_type
    remove_column :users, :notification_key
    remove_column :users, :token_key
    rename_column :users, :mobile, :phone
    rename_column :users, :name, :first_name
    add_column :users, :last_name, :string
  end
end
