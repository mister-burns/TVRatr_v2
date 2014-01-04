class AddAmazonOwnAvailabilityToShow < ActiveRecord::Migration
  def change
    add_column :shows, :amazon_own_availability, :text
  end
end
