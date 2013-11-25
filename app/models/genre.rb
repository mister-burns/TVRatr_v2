class Genre < ActiveRecord::Base
  validates :genre, uniqueness: true
end
