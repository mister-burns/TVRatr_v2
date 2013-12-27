class AddSerializedToShow < ActiveRecord::Migration
  def change
    add_column :shows, :serialized, :boolean
  end
end
