class WikipediaApiQuery < ActiveRecord::Base
  validates :wikipedia_page_id, uniqueness: true
end
