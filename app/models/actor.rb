class Actor < ActiveRecord::Base
  belongs_to :show
  validates :name, :uniqueness => { :scope => :show_id }
end
