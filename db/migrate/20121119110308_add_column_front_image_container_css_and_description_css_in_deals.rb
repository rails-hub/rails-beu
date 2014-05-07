class AddColumnFrontImageContainerCssAndDescriptionCssInDeals < ActiveRecord::Migration
  def up
    add_column :deals, :front_image_container_css, :string
    add_column :deals, :description_css, :string
 
  end

  def down
    remove_column :deals, :front_image_container_css
    remove_column :deals, :description_css
  end
end
