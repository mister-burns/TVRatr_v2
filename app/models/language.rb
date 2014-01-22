class Language < ActiveRecord::Base
  has_many :language_shows
  has_many :shows, :through => :language_shows

  validates :name, uniqueness: true, presence: true
end
