class AddAmazonInstantAvailabilityToShow < ActiveRecord::Migration
  def change
    add_column :shows, :amazon_instant_availability, :text
  end
end
