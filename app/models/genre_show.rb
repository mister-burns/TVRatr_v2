class GenreShow < ActiveRecord::Base
  belongs_to :genre
  belongs_to :show

  validates :genre_id, :uniqueness => { :scope => :show_id }
end
