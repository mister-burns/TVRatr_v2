class Genre < ActiveRecord::Base
  has_many :genre_shows
  has_many :shows, :through => :genre_shows

  validates :name, uniqueness: true, presence: true
end
