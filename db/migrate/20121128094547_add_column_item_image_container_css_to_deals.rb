class AddColumnItemImageContainerCssToDeals < ActiveRecord::Migration
  def up
    add_column :deals, :item_image_container_css, :string
  end

  def down
    remove_column :deals, :item_image_container_css
  end
end
