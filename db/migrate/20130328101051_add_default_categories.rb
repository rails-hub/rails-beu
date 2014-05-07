class AddDefaultCategories < ActiveRecord::Migration
  def up
    Admin::ClassifiedCategory.create(:name => "Real Estate")
    Admin::ClassifiedCategory.create(:name => "Help Wanted")
    Admin::ClassifiedCategory.create(:name => "Local Events")
    Admin::ClassifiedCategory.create(:name => "Items for Sale")
    Admin::ClassifiedCategory.create(:name => "Office Space")
  end

  def down
  end
end
