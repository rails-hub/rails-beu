class AddSmartphoneapiRelatedColumnsToDeals < ActiveRecord::Migration
  def up
    add_column :deals, :coupon_no, :string
    add_column :deals, :redemption_code, :string
    add_column :deals, :value, :string
    add_column :deals, :image_url, :string
    add_column :deals, :item_name, :string
    add_column :deals, :store_id, :integer
  end
  def down
    remove_column :deals, :coupon_no
    remove_column :deals, :redemption_code
    remove_column :deals, :value
    remove_column :deals, :image_url
    remove_column :deals, :item_name
    remove_column :deals, :store_id
  end
end
