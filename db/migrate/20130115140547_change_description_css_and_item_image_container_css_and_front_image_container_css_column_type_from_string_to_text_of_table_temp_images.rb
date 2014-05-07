class ChangeDescriptionCssAndItemImageContainerCssAndFrontImageContainerCssColumnTypeFromStringToTextOfTableTempImages < ActiveRecord::Migration
  def up
    change_table :temp_images do |t|
        t.change :description_css, :text
        t.change :item_image_container_css, :text
        t.change :front_image_container_css, :text
    end
  end

  def down
    change_table :temp_images do |t|
        t.change :description_css, :string
        t.change :item_image_container_css, :string
        t.change :front_image_container_css, :string
    end
  end
end
