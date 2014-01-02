class AddImdbActorsToShow < ActiveRecord::Migration
  def change
    add_column :shows, :imdb_actors, :text
  end
end
