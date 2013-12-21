class AddTvDotComRatingToShow < ActiveRecord::Migration
  def change
    add_column :shows, :tv_dot_com_rating, :float
  end
end
