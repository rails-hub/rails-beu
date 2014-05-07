class AddColumnItemImageContainerCssToTempImages < ActiveRecord::Migration
  def up
    add_column :temp_images, :item_image_container_css, :string
  end

  def down
    remove_column :temp_images, :item_image_container_css
  end
end
