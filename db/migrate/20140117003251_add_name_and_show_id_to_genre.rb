class AddNameAndShowIdToGenre < ActiveRecord::Migration
  def change
    add_column :genres, :show_id, :integer
    add_column :genres, :name, :string
  end
end
