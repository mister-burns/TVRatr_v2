class RemoveGenresFromShow < ActiveRecord::Migration
  def change
    remove_column :shows, :genre_1, :string
    remove_column :shows, :genre_2, :string
    remove_column :shows, :genre_3, :string
    remove_column :shows, :genre_4, :string
    remove_column :shows, :genre_5, :string
  end
end
