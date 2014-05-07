class AddAttachmentLocalFinalLargeImgFinalLargeImgToTempImages < ActiveRecord::Migration
  def self.up
    change_table :temp_images do |t|
      t.has_attached_file :local_final_large_img
      t.has_attached_file :final_large_img
    end
  end

  def self.down
    drop_attached_file :temp_images, :local_final_large_img
    drop_attached_file :temp_images, :final_large_img
  end
end
