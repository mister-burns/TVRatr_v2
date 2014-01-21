class Country < ActiveRecord::Base
  has_many :country_shows
  has_many :shows, :through => :country_shows

  validates :name, uniqueness: true, presence: true
end
