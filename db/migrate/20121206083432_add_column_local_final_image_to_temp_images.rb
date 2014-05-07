class AddColumnLocalFinalImageToTempImages < ActiveRecord::Migration
  def change
	add_attachment :temp_images, :local_final_image
  end
end
