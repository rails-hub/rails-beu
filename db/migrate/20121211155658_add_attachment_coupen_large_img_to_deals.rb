class AddAttachmentCoupenLargeImgToDeals < ActiveRecord::Migration
  def self.up
    change_table :deals do |t|
      t.has_attached_file :coupen_large_img
    end
  end

  def self.down
    drop_attached_file :deals, :coupen_large_img
  end
end
