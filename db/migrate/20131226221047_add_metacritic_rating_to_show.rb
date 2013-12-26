class AddMetacriticRatingToShow < ActiveRecord::Migration
  def change
    add_column :shows, :metacritic_rating, :text
  end
end
