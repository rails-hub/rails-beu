class ChangeNameToAdminClassfieds < ActiveRecord::Migration
  def up
    change_column :admin_classifieds, :name, :text
  end

  def down
    change_column :admin_classifieds, :name, :string
  end
end
