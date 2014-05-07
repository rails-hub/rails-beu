class AddColumnBackImageOrColorIntoDeals < ActiveRecord::Migration
  def up
    add_column :deals, :back_image_or_color, :boolean
  end

  def down
    remove_column :deals, :back_image_or_color
  end
end
