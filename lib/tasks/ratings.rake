task :get_imdb_ratings_individual_show => :environment do
  require 'mechanize'

  show = Show.where(:wikipedia_page_id => 20715044)
  name = show.show_name
  url = "http://www.imdb.com"

  agent = Mechanize.new
  agent.get(url)
  search_form = agent.page.form_with(:action => "/find")
  search_form.q = name
  search_form.s = "tt"
  search_form.submit
  agent.page.link_with(:text => name).click
  value = agent.page.at(".titlePageSprite.star-box-giga-star").text.strip
  puts value
  show.imdb_rating = value
  show.save

end


task :get_imdb_ratings_group => :environment do
  require 'mechanize'

  url = "http://www.imdb.com"
  show = Show.individual_season_filter.remove_wikipedia_categories.where(:serialized => true)
  #show = Show.individual_season_filter.remove_wikipedia_categories.where('number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1)
  #show = Show.individual_season_filter.remove_wikipedia_categories.where( 'number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1 ).where('imdb_rating IS NULL')
  show.each do |show|

    string = show.show_name
    name = string.gsub(/\(.*?\)/i,"").strip
    puts name
    agent = Mechanize.new
    agent.get(url)
    search_form = agent.page.form_with(:action => "/find")
    search_form.q = name
    search_form.s = "tt"
    search_form.submit
    if agent.page.link_with(:text => name).present?
      agent.page.link_with(:text => name).click
      if agent.page.at(".titlePageSprite.star-box-giga-star").present?
        rating = agent.page.at(".titlePageSprite.star-box-giga-star").text.strip
        rating_count = agent.page.at("span[itemprop=ratingCount]").text.strip.gsub(/,/,"").to_i
        puts rating
        puts rating_count
        puts rating_count.class
        show.imdb_rating = rating
        show.imdb_rating_count = rating_count
        show.save
      end
    end
    #sleep(1)
  end
end


task :get_tv_dot_com_ratings => :environment do
  require 'mechanize'

  url = "http://www.tv.com"
  show = Show.individual_season_filter.remove_wikipedia_categories.where('number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1).where('tv_dot_com_rating IS NULL')
  show.each do |show|

    string = show.show_name
    name = string.gsub(/\(.*?\)/i,"").strip
    puts name
    agent = Mechanize.new
    agent.get(url)
    search_form = agent.page.form_with(:action => "/search")
    search_form.q = name
    search_form.submit
    if agent.page.link_with(:text => name).present?
      agent.page.link_with(:text => name).click
      if agent.page.at(".score").present?
        value = agent.page.at(".score").text.strip
        puts value
        show.tv_dot_com_rating = value
        show.save
      end
    end
    #sleep(1)
  end
end


task :get_metacritic_ratings => :environment do
  require 'mechanize'

  url = "http://www.metacritic.com"
  show = Show.individual_season_filter.remove_wikipedia_categories.where('number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1).where('tv_dot_com_rating IS NULL')
  show.each do |show|

    string = show.show_name
    name = string.gsub(/\(.*?\)/i,"").strip

    puts name
    agent = Mechanize.new
    agent.get(url)
    search_form = agent.page.form_with(:action => "/search")
    search_form.search_term = name
    search_form.submit
    if agent.page.link_with(:text => name).present?
      agent.page.link_with(:text => name).click
      if agent.page.at(".score").present?
        value = agent.page.at(".score").text.strip
        puts value
        show.tv_dot_com_rating = value
        show.save
      end
    end
    #sleep(1)
  end
end