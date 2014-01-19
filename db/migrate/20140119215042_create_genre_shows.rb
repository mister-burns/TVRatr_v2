class CreateGenreShows < ActiveRecord::Migration
  def change
    create_table :genre_shows do |t|
      t.integer :genre_id
      t.integer :show_id

      t.timestamps
    end
  end
end
