class AddNumSeriesToShow < ActiveRecord::Migration
  def change
    add_column :shows, :number_of_series, :integer
  end
end
