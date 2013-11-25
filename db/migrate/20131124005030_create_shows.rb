class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.integer :wikipedia_page_id
      t.string :show_name
      t.datetime :first_aired
      t.datetime :last_aired
      t.boolean :show_active
      t.integer :number_of_episodes
      t.integer :number_of_seasons
      t.string :genre_1
      t.string :genre_2
      t.string :genre_3
      t.string :genre_4
      t.string :genre_5
      t.string :format_1
      t.string :format_2
      t.string :format_3
      t.string :format_4
      t.string :format_5
      t.string :country_1
      t.string :country_2
      t.string :country_3
      t.string :network_1
      t.string :network_2
      t.string :language

      t.timestamps
    end
  end
end
