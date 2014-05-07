class AddColumnFrontImageContainerCssAndDescriptionCssInTempImages < ActiveRecord::Migration
   def up
    add_column :temp_images, :front_image_container_css, :string
    add_column :temp_images, :description_css, :string

  end

  def down
    remove_column :temp_images, :front_image_container_css
    remove_column :temp_images, :description_css
  end
end
