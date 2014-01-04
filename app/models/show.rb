class Show < ActiveRecord::Base
  validates :wikipedia_page_id, uniqueness: true, presence: true
  serialize :metacritic_rating
  serialize :imdb_actors

  scope :genre_search, -> { where("genre_1 LIKE ? OR genre_2 LIKE ? OR genre_3 LIKE ? OR genre_4 LIKE ? OR genre_5 LIKE ? OR format_1 LIKE ? OR format_2 LIKE ? OR format_3 LIKE ? OR format_4 LIKE ? OR format_5 LIKE ?", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%") }

  # Use this scope to filter out bad data from wikipedia. Some shows (ex. sons of anarchy) have individual seasons listed as
  # full shows. This is obviously incorrect and not what my users want to see. This scope weeds out those entries.
  scope :individual_season_filter, -> { where("show_name NOT LIKE ?", "%(season%") }
  scope :remove_wikipedia_categories, -> { where("show_name NOT LIKE ?", "%category:%") }
  scope :english_only, -> { where(t[:language].matches("%english%").or(t[:country_1].matches("%united%")).or(t[:country_1].matches("%austrailia%")).or(t[:country_1].matches("%england%")).or(t[:country_1].matches("%uk%")).or(t[:country_1].matches("%ireland%")).or(t[:country_1].matches("%new zealand%")) ) }


  def self.show_name_search(show_name_search)
    if show_name_search.present?
      where('show_name LIKE ?', "%#{show_name_search}%")
    else
      Show.all
    end
  end

  def self.network_search(network_search)
    if network_search.present?
      where('network_1 LIKE ? OR network_2 LIKE ?', "%#{network_search}%", "%#{network_search}%")
    else
      Show.all
    end
  end

  def self.amazon_instant_filter(amazon_instant)
    if amazon_instant.present?
      where('amazon_instant_availability IS NOT NULL')
    else
      Show.all
    end
  end

  def self.amazon_own_filter(amazon_own)
    if amazon_own.present?
      where('amazon_own_availability IS NOT NULL')
    else
      Show.all
    end
  end



  def self.min_imdb_rating(min_imdb_rating)
    if min_imdb_rating.present?
      where('imdb_rating >= ?', min_imdb_rating)
    else
      all
    end
  end

  def self.max_imdb_rating(max_imdb_rating)
    if max_imdb_rating.present?
      where('imdb_rating <= ?', max_imdb_rating)
    else
      Show.all
    end
  end

  def self.min_metacritic_rating(min_metacritic_average_rating)
    if min_metacritic_average_rating.present?
      where('metacritic_average_rating >= ?', min_metacritic_average_rating)
    else
      Show.all
    end
  end

  def self.max_metacritic_rating(max_metacritic_average_rating)
    if max_metacritic_average_rating.present?
      where('metacritic_average_rating <= ?', max_metacritic_average_rating)
    else
      Show.all
    end
  end

  def self.min_tv_dot_com_rating(min_tv_dot_com_rating)
    if min_tv_dot_com_rating.present?
      where('tv_dot_com_rating >= ?', min_tv_dot_com_rating)
    else
      Show.all
    end
  end

  def self.max_tv_dot_com_rating(max_tv_dot_com_rating)
    if max_tv_dot_com_rating.present?
      where('tv_dot_com_rating <= ?', max_tv_dot_com_rating)
    else
      Show.all
    end
  end

  def self.imdb_min_rating_count(imdb_min_rating_count)
    if imdb_min_rating_count.present?
      where('imdb_rating_count >= ?', imdb_min_rating_count)
    else
      Show.all
    end
  end

  def self.tv_dot_com_min_rating_count(tv_dot_com_min_rating_count)
    if tv_dot_com_min_rating_count.present?
      where('tv_dot_com_rating_count >= ?', tv_dot_com_min_rating_count)
    else
      Show.all
    end
  end

  def self.combo_filter(drama, comedy)
    t = arel_table
    @string = ""

    if drama.present?
      @drama = drama
    else
      @drama = "%%"
    end

    if comedy.present?
      @comedy = comedy
    else
      @comedy = "%%"
    end

    if drama.present? || comedy.present?
      #@string = t[:genre_1].matches('%drama%').or(t[:genre_2].matches('%drama%')).or(t[:genre_3].matches('%drama%')).or(t[:genre_4].matches('%drama%')).or(t[:genre_5].matches('%drama%')).or(t[:format_1].matches('%drama%')).or(t[:format_2].matches('%drama%')).or(t[:format_3].matches('%drama%')).or(t[:format_4].matches('%drama%')).or(t[:format_5].matches('%drama%'))
      #@string = t[:genre_1].matches("%#{drama}%").or(t[:genre_2].matches("%#{drama}%")).or(t[:genre_3].matches("%#{drama}%")).or(t[:genre_4].matches("%#{drama}%")).or(t[:genre_5].matches("%#{drama}%")).or(t[:format_1].matches("%#{drama}%")).or(t[:format_2].matches("%#{drama}%")).or(t[:format_3].matches("%#{drama}%")).or(t[:format_4].matches("%#{drama}%")).or(t[:format_5].matches("%#{drama}%"))
      where('genre_1 LIKE ? OR genre_1 LIKE ?', "%#{@drama}%", "%#{@comedy}%")
      #where(t[:genre_1].matches("%#{@drama}%").or(t[:genre_1].matches("%#{@comedy}%")) )
    else
      Show.all
    end

    #arel_table[:description].matches("%#{summary_description}%") unless !summary_description.nil?  .or

    #if comedy.present? && @string != ""
    #  @comedy = ".or(" + t[:genre_1].matches("%#{comedy}%")).or(t[:genre_2].matches("%#{comedy}%")).or(t[:genre_3].matches("%#{comedy}%")).or(t[:genre_4].matches("%#{comedy}%")).or(t[:genre_5].matches("%#{comedy}%")).or(t[:format_1].matches("%#{comedy}%")).or(t[:format_2].matches("%#{comedy}%")).or(t[:format_3].matches("%#{comedy}%")).or(t[:format_4].matches("%#{comedy}%")).or(t[:format_5].matches("%#{comedy}%"))
    #  @string = @string + @comedy
    #elsif comedy.present? && @string == ""
    #  @string = t[:genre_1].matches("%#{comedy}%")).or(t[:genre_2].matches("%#{comedy}%")).or(t[:genre_3].matches("%#{comedy}%")).or(t[:genre_4].matches("%#{comedy}%")).or(t[:genre_5].matches("%#{comedy}%")).or(t[:format_1].matches("%#{comedy}%")).or(t[:format_2].matches("%#{comedy}%")).or(t[:format_3].matches("%#{comedy}%")).or(t[:format_4].matches("%#{comedy}%")).or(t[:format_5].matches("%#{comedy}%"))
    #else
    #  @string = ""
    #end

    #if drama.present? || comedy.present?
    #  where(t[:genre_1].matches('%drama%').or(t[:genre_2].matches('%drama%')).or(t[:genre_3].matches('%drama%')).or(t[:genre_4].matches('%drama%')).or(t[:genre_5].matches('%drama%')).or(t[:format_1].matches('%drama%')).or(t[:format_2].matches('%drama%')).or(t[:format_3].matches('%drama%')).or(t[:format_4].matches('%drama%')).or(t[:format_5].matches('%drama%')))
    #else
    #  Show.all
    #end
  end

  def self.drama_filter(drama)
    t = arel_table
    if drama.present?
      where(t[:genre_1].matches('%drama%').or(t[:genre_2].matches('%drama%')).or(t[:genre_3].matches('%drama%')).or(t[:genre_4].matches('%drama%')).or(t[:genre_5].matches('%drama%')).or(t[:format_1].matches('%drama%')).or(t[:format_2].matches('%drama%')).or(t[:format_3].matches('%drama%')).or(t[:format_4].matches('%drama%')).or(t[:format_5].matches('%drama%')))
    else
      Show.all
    end
  end

  def self.comedy_filter(comedy)
    t = arel_table
    if comedy.present?
      where(t[:genre_1].matches("%#{comedy}%").or(t[:genre_2].matches("%#{comedy}%")).or(t[:genre_3].matches("%#{comedy}%")).or(t[:genre_4].matches("%#{comedy}%")).or(t[:genre_5].matches("%#{comedy}%")).or(t[:format_1].matches("%#{comedy}%")).or(t[:format_2].matches("%#{comedy}%")).or(t[:format_3].matches("%#{comedy}%")).or(t[:format_4].matches("%#{comedy}%")).or(t[:format_5].matches("%#{comedy}%")) )
    else
      Show.all
    end
  end

  def self.language_filter(language)
    t = arel_table
    if language.present?
      where(t[:language].matches("%english%").or(t[:country_1].matches("%united%")).or(t[:country_1].matches("%austrailia%")).or(t[:country_1].matches("%england%")).or(t[:country_1].matches("%uk%")).or(t[:country_1].matches("%ireland%")).or(t[:country_1].matches("%new zealand%")) )
    else
      Show.all
    end
  end

  def self.serialized_only_filter(serialized_only)
    t = arel_table
    if serialized_only.present?
      #where("genre_1 LIKE ? OR genre_2 LIKE ? OR genre_3 LIKE ? OR genre_4 LIKE ? OR genre_5 LIKE ? OR format_1 LIKE ? OR format_2 LIKE ? OR format_3 LIKE ? OR format_4 LIKE ? OR format_5 LIKE ?", "%serial%", "%serial%", "%serial%", "%serial%", "%serial%", "%serial%", "%serial%", "%serial%", "%serial%", "%serial%")
      where(t[:genre_1].matches("%serial%").or(t[:genre_2].matches("%serial%")).or(t[:genre_3].matches("%serial%")).or(t[:genre_4].matches("%serial%")).or(t[:genre_5].matches("%serial%")).or(t[:format_1].matches("%serial%")).or(t[:format_2].matches("%serial%")).or(t[:format_3].matches("%serial%")).or(t[:format_4].matches("%serial%")).or(t[:format_5].matches("%serial%")).or(t[:serialized].eq(true)) )
    else
      Show.all
    end
  end

  def self.united_states_filter(united_states)
    t = arel_table
    if united_states.present?
      where(t[:country_1].matches("%united states%").or(t[:country_1].matches("US")).or(t[:country_1].matches("%america%")).or(t[:country_2].matches("%united states%")).or(t[:country_2].matches("US")).or(t[:country_2].matches("%america%")) )
    else
      Show.all
    end
  end

  def self.united_kingdom_filter(united_kingdom)
    t = arel_table
    if united_kingdom.present?
      where(t[:country_1].matches("%united kingdom%").or(t[:country_1].matches("UK")).or(t[:country_1].matches("%england%")).or(t[:country_1].matches("%wales%")).or(t[:country_1].matches("%scotland%")).or(t[:country_2].matches("%united kingdom%")).or(t[:country_2].matches("%wales%")).or(t[:country_2].matches("UK")).or(t[:country_2].matches("%england%")).or(t[:country_2].matches("%scotland%")) )
    else
      Show.all
    end
  end

  def self.commonwealth_filter(commonwealth)
    t = arel_table
    if commonwealth.present?
      where(t[:country_1].matches("%australia%").or(t[:country_1].matches("%canada")).or(t[:country_1].matches("%ireland%")).or(t[:country_1].matches("%new zealand%")) )
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
  def self.genre_filter(horror, drama)
    if horror || drama
         where("genre_1 LIKE ?", "%#{drama}%")
    else
      Show.all
    end
  end

  def chained_genre_names

    if genre_1.present?
      @chain = genre_1.to_s
    else
      @chain = ""
    end

    if genre_2.present? && @chain != ""
      @chain = @chain + ", " + genre_2.to_s
    elsif genre_2.present? && @chain == ""
      @chain = genre_2.to_s
    else
      @chain
    end

    if genre_3.present? && @chain != ""
      @chain = @chain + ", " + genre_3.to_s
    elsif genre_3.present? && @chain == ""
      @chain = genre_3.to_s
    else
      @chain
    end

    if genre_4.present? && @chain != ""
      @chain = @chain + ", " + genre_4.to_s
    elsif genre_4.present? && @chain == ""
      @chain = genre_4.to_s
    else
      @chain
    end

    if genre_5.present? && @chain != ""
      @chain = @chain + ", " + genre_5.to_s
    elsif genre_5.present? && @chain == ""
      @chain = genre_5.to_s
    else
      @chain
    end

    if format_1.present? && @chain != ""
      @chain = @chain + ", " + format_1.to_s
    elsif format_1.present? && @chain == ""
      @chain = format_1.to_s
    else
      @chain
    end

    if format_2.present? && @chain != ""
      @chain = @chain + ", " + format_2.to_s
    elsif format_2.present? && @chain == ""
      @chain = format_2.to_s
    else
      @chain
    end

    if format_3.present? && @chain != ""
      @chain = @chain + ", " + format_3.to_s
    elsif format_3.present? && @chain == ""
      @chain = format_3.to_s
    else
      @chain
    end

    if format_4.present? && @chain != ""
      @chain = @chain + ", " + format_4.to_s
    elsif format_4.present? && @chain == ""
      @chain = format_4.to_s
    else
      @chain
    end

    if format_5.present? && @chain != ""
      @chain = @chain + ", " + format_5.to_s
    elsif format_5.present? && @chain == ""
      @chain = format_5.to_s
    else
      @chain
    end
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
