class AddColumnFinalImageToTempImages < ActiveRecord::Migration
  
  def self.up
      add_attachment :temp_images, :final_image
  end

  def self.down
     remove_attachment :temp_images, :final_image
  end
end
