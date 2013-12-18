class AddFirstAiredStringAndLastAiredStringToShow < ActiveRecord::Migration
  def change
    add_column :shows, :first_aired_string, :string
    add_column :shows, :last_aired_string, :string
  end
end
