class CreateActorShows < ActiveRecord::Migration
  def change
    create_table :actor_shows do |t|
      t.integer :actor_id
      t.integer :show_id

      t.timestamps
    end
  end
end
