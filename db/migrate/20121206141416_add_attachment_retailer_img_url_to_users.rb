class AddAttachmentRetailerImgUrlToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.has_attached_file :retailer_img_url
    end
  end

  def self.down
    drop_attached_file :users, :retailer_img_url
  end
end
