class Show < ActiveRecord::Base
  validates :wikipedia_page_id, uniqueness: true, presence: true


  def modifed_last_aired
    if last_aired == Date.today
      "present"
    else
      last_aired.try(:strftime, "%B %e, %Y")
    end
  end

  def modified_first_aired
    first_aired.try(:strftime, "%B %e, %Y")
  end

  def modified_show_name
    show_name.gsub(/\(tv series\)|\(tv progra(m|me)\)/i, "")
  end

  def self.search(search)
    if search
      where('show_name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

end
