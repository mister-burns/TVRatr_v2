class Show < ActiveRecord::Base
  validates :wikipedia_page_id, uniqueness: true, presence: true

  scope :genre_search, -> { where("genre_1 LIKE ? OR genre_2 LIKE ? OR genre_3 LIKE ? OR genre_4 LIKE ? OR genre_5 LIKE ? OR format_1 LIKE ? OR format_2 LIKE ? OR format_3 LIKE ? OR format_4 LIKE ? OR format_5 LIKE ?", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%") }
  scope :serialized_search, -> { where(:serialized => true) }
  scope :genre_1, -> { where("genre_1 LIKE ?", "%drama%") }

  # @param [Object] search
  def self.search(search)
    if search
      where('show_name LIKE ?', "%#{search}%")
    else
      Show.all
    end
  end

  def self.min_seasons_filter(min_seasons)
    if min_seasons.present?
      where('number_of_seasons >= ?', min_seasons)
    else
      Show.all
    end
  end

  def self.max_seasons_filter(max_seasons)
    if max_seasons.present?
      where('number_of_seasons <= ?', max_seasons)
    else
      Show.all
    end
  end

  def self.min_episodes_filter(min_episodes)
    if min_episodes.present?
      where('number_of_episodes >= ?', min_episodes)
    else
      Show.all
    end
  end

  def self.max_episodes_filter(max_episodes)
    if max_episodes.present?
      where('number_of_episodes <= ?', max_episodes)
    else
      Show.all
    end
  end



  # @param [Object] genre
  def self.genre_filter(genre)
    if genre
       #genre.first do |genre|
         where("genre_1 LIKE ? OR genre_2 LIKE ? OR genre_3 LIKE ? OR genre_4 LIKE ? OR genre_5 LIKE ? OR format_1 LIKE ? OR format_2 LIKE ? OR format_3 LIKE ? OR format_4 LIKE ? OR format_5 LIKE ?", "%#{genre}%", "%#{genre}%", "%#{genre}%", "%#{genre}%", "%#{genre}%", "%#{genre}%", "%#{genre}%", "%#{genre}%", "%#{genre}%", "%#{genre}%")
       #end
    else
      Show.all
    end
  end

  def genre_names
     genre_1.to_s + " " + genre_2.to_s + " " + genre_3.to_s + " " + genre_4.to_s + " " + genre_5.to_s + " " + format_1.to_s + " " + format_2.to_s + " " + format_3.to_s + " " + format_4.to_s + " " + format_5.to_s
  end

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

  def modified_language
    if language.nil?
      nil
    else
      language.gsub(/language/i, "")
    end
  end


end
