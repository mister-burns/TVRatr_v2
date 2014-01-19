class DropShowAttributeTypes < ActiveRecord::Migration
  def change
    drop_table :show_attribute_types
  end
end
