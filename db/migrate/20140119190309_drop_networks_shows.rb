class DropNetworksShows < ActiveRecord::Migration
  def change
    drop_table :networks_shows
  end
end
