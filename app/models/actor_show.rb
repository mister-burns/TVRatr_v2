class ActorShow < ActiveRecord::Base
  belongs_to :actor
  belongs_to :show

  validates :actor_id, :uniqueness => { :scope => :show_id }
end
