class RemoveNetworksFromShow < ActiveRecord::Migration
  def change
    remove_column :shows, :network_1, :string
    remove_column :shows, :network_2, :string
  end
end
