class CreateWikipediaApiQueries < ActiveRecord::Migration
  def change
    create_table :wikipedia_api_queries do |t|
      t.integer :wikipedia_page_id
      t.string :show_name
      t.text :infobox

      t.timestamps
    end
  end
end
