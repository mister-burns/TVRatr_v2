class CreateCountryShows < ActiveRecord::Migration
  def change
    create_table :country_shows do |t|
      t.integer :country_id
      t.integer :show_id

      t.timestamps
    end
  end
end
