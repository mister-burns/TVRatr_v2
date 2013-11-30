class AddLastAiredPresentToShow < ActiveRecord::Migration
  def change
    add_column :shows, :last_aired_present, :string
  end
end
