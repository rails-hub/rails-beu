class RenameTitleToNameRemoveColumnsDescriptionAndUrlFromQuestions < ActiveRecord::Migration
  def up
    rename_column :questions, :title, :name
    remove_column :questions, :description
    remove_column :questions, :url
    add_column :questions,:is_active, :boolean
  end

  def down
    rename_column :questions, :name, :title
    add_column :questions, :description, :string
    add_column :questions, :url, :string
    remove_column :questions,:is_active
  end
end
