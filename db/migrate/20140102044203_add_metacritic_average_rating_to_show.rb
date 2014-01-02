class AddMetacriticAverageRatingToShow < ActiveRecord::Migration
  def change
    add_column :shows, :metacritic_average_rating, :float
  end
end
