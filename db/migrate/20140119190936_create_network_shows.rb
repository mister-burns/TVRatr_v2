class CreateNetworkShows < ActiveRecord::Migration
  def change
    create_table :network_shows do |t|
      t.integer :network_id
      t.integer :show_id

      t.timestamps
    end
  end
end
