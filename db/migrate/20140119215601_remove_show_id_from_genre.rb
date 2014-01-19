class RemoveShowIdFromGenre < ActiveRecord::Migration
  def change
    remove_column :genres, :show_id, :integer
  end
end
