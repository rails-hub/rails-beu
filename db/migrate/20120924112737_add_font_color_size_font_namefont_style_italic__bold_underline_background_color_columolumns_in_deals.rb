class AddFontColorSizeFontNamefontStyleItalicBoldUnderlineBackgroundColorColumolumnsInDeals < ActiveRecord::Migration
  def up
    add_column :deals, :font_name, :string
    add_column :deals, :font_color, :string
    add_column :deals, :font_size, :string
    add_column :deals, :italic, :boolean
    add_column :deals, :bold, :boolean
    add_column :deals, :underline, :boolean
    add_column :deals, :background_color, :string
  end

  def down
    remove_column :deals, :font_name
    remove_column :deals, :font_color
    remove_column :deals, :font_size
    remove_column :deals, :italic
    remove_column :deals, :bold
    remove_column :deals, :underline
    remove_column :deals, :background_color
  end
end
