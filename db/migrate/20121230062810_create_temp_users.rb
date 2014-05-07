class CreateTempUsers < ActiveRecord::Migration
  
  def self.up
    create_table :temp_users do |t|
      t.has_attached_file :retailer_image
      t.string :session_id
      
    end
  end

  def self.down
    drop_table :temp_users
    #    drop_attached_file :temp_users, :retailer_image
    #    remove_column :temp_users, :session_id
  end

end
