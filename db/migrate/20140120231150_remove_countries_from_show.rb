class RemoveCountriesFromShow < ActiveRecord::Migration
  def change
    remove_column :shows, :country_1, :string
    remove_column :shows, :country_2, :string
    remove_column :shows, :country_3, :string
  end
end
