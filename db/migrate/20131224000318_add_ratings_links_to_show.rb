class AddRatingsLinksToShow < ActiveRecord::Migration
  def change
    add_column :shows, :imdb_link, :string
    add_column :shows, :tv_dot_com_link, :string
  end
end
