class AddItunesLinkToShow < ActiveRecord::Migration
  def change
    add_column :shows, :itunes_link, :text
  end
end
