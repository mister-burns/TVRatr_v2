class RemoveShowIdFromActor < ActiveRecord::Migration
  def change
    remove_column :actors, :show_id, :integer
  end
end
