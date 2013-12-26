class AddMetacriticLinkToShow < ActiveRecord::Migration
  def change
    add_column :shows, :metacritic_link, :string
  end
end
