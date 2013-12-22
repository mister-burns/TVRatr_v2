class AddRatingCountsToShow < ActiveRecord::Migration
  def change
    add_column :shows, :imdb_rating_count, :integer
    add_column :shows, :tv_dot_com_rating_count, :integer
    add_column :shows, :metacritic_rating_count, :integer
  end
end
