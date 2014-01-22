class LanguageShow < ActiveRecord::Base
  belongs_to :language
  belongs_to :show

  validates :language_id, :uniqueness => { :scope => :show_id }
end
