class RemoveGenreFromGenre < ActiveRecord::Migration
  def change
    remove_column :genres, :genre, :string
  end
end
