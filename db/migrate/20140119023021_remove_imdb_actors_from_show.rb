class RemoveImdbActorsFromShow < ActiveRecord::Migration
  def change
    remove_column :shows, :imdb_actors, :text
  end
end
