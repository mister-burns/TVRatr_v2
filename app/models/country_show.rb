class CountryShow < ActiveRecord::Base
  belongs_to :country
  belongs_to :show

  validates :country_id, :uniqueness => { :scope => :show_id }
end
