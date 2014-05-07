class RemoveIndexFromUsersOnEmail < ActiveRecord::Migration
  def up
             #add_index :users, :email
    remove_index :users, :column => [:email]

  end

  def down

  end
end
