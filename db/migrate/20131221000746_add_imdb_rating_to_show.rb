class AddImdbRatingToShow < ActiveRecord::Migration
  def change
    add_column :shows, :imdb_rating, :float
  end
end
