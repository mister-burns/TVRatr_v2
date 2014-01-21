class Actor < ActiveRecord::Base
  has_many :actor_shows
  has_many :shows, :through => :actor_shows

  validates :name, uniqueness: true, presence: true

end
