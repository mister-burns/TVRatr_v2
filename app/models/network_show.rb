class NetworkShow < ActiveRecord::Base
  belongs_to :network
  belongs_to :show

  validates :network_id, :uniqueness => { :scope => :show_id }
end
