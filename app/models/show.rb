class Show < ActiveRecord::Base
  validates :wikipedia_page_id, uniqueness: true, presence: true


  def modified_last_aired
    if last_aired_present == "present"
      "present"
    elsif last_aired.try(:strftime, "%m%d") == "0101"
      last_aired.try(:strftime, "%Y")
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

  def modified_number_of_seasons
     if number_of_seasons.nil?
       number_of_series
     else
       number_of_seasons
     end
  end

  def modified_network_1
    if network_1.nil?
      nil
    else
      network_1.gsub(/\(tv channel\)|\(tv network\)|\(U\.?S\.? TV (channel|network)\)|\(United States\)/i, "")
    end
  end

end
