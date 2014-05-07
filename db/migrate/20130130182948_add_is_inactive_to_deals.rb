class AddIsInactiveToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :is_inactive, :boolean, :default=>false
  end
end
