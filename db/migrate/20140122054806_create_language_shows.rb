class CreateLanguageShows < ActiveRecord::Migration
  def change
    create_table :language_shows do |t|
      t.integer :language_id
      t.integer :show_id

      t.timestamps
    end
  end
end
