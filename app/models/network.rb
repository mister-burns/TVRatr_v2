class Network < ActiveRecord::Base
  has_many :network_shows
  has_many :shows, :through => :network_shows

  validates :name, uniqueness: true, presence: true
end
