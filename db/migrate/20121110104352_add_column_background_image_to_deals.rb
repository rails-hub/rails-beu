class AddColumnBackgroundImageToDeals < ActiveRecord::Migration
   def self.up
      add_attachment :deals, :background_image
  end

  def self.down
     remove_attachment :deals, :background_image
  end
end
