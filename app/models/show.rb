class Show < ActiveRecord::Base
  validates :wikipedia_page_id, uniqueness: true, presence: true


  def modifed_last_aired
    if last_aired == Date.today
      "present"
    else
      last_aired.try(:strftime, "%B %e, %Y")
    end
  end

  def modifed_first_aired
    first_aired.try(:strftime, "%B %e, %Y")
  end

  def modifed_show_name
    show_name.gsub(/\(tv series\)|\(tv progra(m|me)\)/i, "")
  end

  def genre_and_format_list
    "#{genre_1}, #{genre_2}"
  end

end
