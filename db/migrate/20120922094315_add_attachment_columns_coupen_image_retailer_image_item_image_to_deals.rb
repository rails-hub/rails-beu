class AddAttachmentColumnsCoupenImageRetailerImageItemImageToDeals < ActiveRecord::Migration
  def self.up
    add_attachment :deals, :coupen_image
    add_attachment :deals, :retailer_image
    add_attachment :deals, :item_image
  end

  def self.down
    remove_attachment :deals, :coupen_image
    remove_attachment :deals, :retailer_image
    remove_attachment :deals, :item_image
    
  end
end
