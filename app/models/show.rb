class Show < ActiveRecord::Base
  has_many :actors
  has_many :genres
  validates :wikipedia_page_id, uniqueness: true, presence: true
  serialize :metacritic_rating
  serialize :imdb_actors

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

  def self.first_aired_filter(start_date_after, start_date_before)
    if start_date_after.present? || start_date_before.present?
      
      if start_date_after["after_date(1i)"].present? then after_year = start_date_after["after_date(1i)"].to_i else after_year = 1940 end
      if start_date_after["after_date(2i)"].present? then after_month = start_date_after["after_date(2i)"].to_i else after_month = 1 end
      if start_date_after["after_date(3i)"].present? then after_day = start_date_after["after_date(3i)"].to_i else after_day = 1 end

      if start_date_before["before_date(1i)"].present? then before_year = start_date_before["before_date(1i)"].to_i else before_year = (Time.now.year + 1) end
      if start_date_before["before_date(2i)"].present? then before_month = start_date_before["before_date(2i)"].to_i else before_month = 1 end
      if start_date_before["before_date(3i)"].present? then before_day = start_date_before["before_date(3i)"].to_i else before_day = 1 end
      
      after_date = Date.new(after_year, after_month, after_day)
      before_date = Date.new(before_year, before_month, before_day)
      
      where('first_aired > ? AND first_aired < ?', after_date, before_date)
    else
      Show.all
    end
  end

  def self.last_aired_filter(last_aired_before)
    if last_aired_before.present?

      if last_aired_before["before_date(1i)"].present? then before_year = last_aired_before["before_date(1i)"].to_i else before_year = (Time.now.year + 1) end
      if last_aired_before["before_date(2i)"].present? then before_month = last_aired_before["before_date(2i)"].to_i else before_month = 1 end
      if last_aired_before["before_date(3i)"].present? then before_day = last_aired_before["before_date(3i)"].to_i else before_day = 1 end

      before_date = Date.new(before_year, before_month, before_day)

      where('last_aired > ?', before_date)
    else
      Show.all
    end
  end

  def self.actor_search(actor_search)
    if actor_search.present?
      joins(:actors).where('actors.name LIKE ?', "%#{actor_search}%" ).uniq
    else
      Show.all
    end
  end


  def self.serialized_filter(serialized_only)
    if serialized_only.present?
      joins(:genres).where('genres.name LIKE ? OR genres.name LIKE ?', "%#{serialized_only}%", "%serialized%" ).uniq
    else
      Show.all
    end
  end


  def self.genre_filter(drama, comedy, horror, children, crime, police, sitcom, science_fiction, genre_search)
    genre_array = Array.new
    if drama.present? then genre_array << drama end
    if comedy.present? then genre_array << comedy end
    if horror.present? then genre_array << horror end
    if children.present? then genre_array << children << "kids" end
    if crime.present? then genre_array << crime end
    if police.present? then genre_array << police << "detective" end
    if sitcom.present? then genre_array << sitcom end
    if science_fiction.present? then genre_array << science_fiction << "sci fi" << "scifi" << "science" end
    if genre_search.present? then genre_array << genre_search end
    if genre_array.present?
      #Check if the following like in safe from SQL injection attack:
      joins(:genres).where(genre_array.map{|genre| "genres.name LIKE '%#{genre}%'" }.join(' OR ')).uniq
      #joins(:genres).where(genre_array.map{|genre| "genres.name LIKE '%#{genre}%'" }.join(' OR ')).uniq
      #http://stackoverflow.com/questions/17990419/rails-or-query-with-join-and-like
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


  def self.availability_filter(amazon_instant, amazon_own, itunes)
    availability_array = Array.new
    if amazon_instant.present? then availability_array << "amazon_instant_availability" end
    if amazon_own.present? then availability_array << "amazon_own_availability" end
    if itunes.present? then availability_array << "itunes_link" end
    if availability_array.present?
      where(availability_array.map{|availability| "#{availability} IS NOT NULL" }.join(' OR '))
    else
      Show.all
    end
  end

  #saved for future reference if needed
  #def self.amazon_instant_filter(amazon_instant)
    #if amazon_instant.present?
      #where('amazon_instant_availability IS NOT NULL')
    #else
      #Show.all
    #end
  #end

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
