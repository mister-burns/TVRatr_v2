task :get_imdb_ratings_group => :environment do
  require 'mechanize'

  url = "http://www.imdb.com"
  show = Show.individual_season_filter.remove_wikipedia_categories.where(:serialized => true)
  #show = Show.where(:wikipedia_page_id => 36860986)
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
    if agent.page.link_with(:text => /#{name}/i).present?
      #agent.page.at('a[text()*=name]')[:href] # match anywhere
      #links_with(:href => %r{^http://www.nytimes.com}i)
      agent.page.link_with(:text => /#{name}/i).click
      if agent.page.at(".titlePageSprite.star-box-giga-star").present?
        rating = agent.page.at(".titlePageSprite.star-box-giga-star").text.strip
        rating_count = agent.page.at("span[itemprop=ratingCount]").text.strip.gsub(/,/,"").to_i
        page_link = agent.page.uri.to_s
        puts rating
        puts rating_count
        show.imdb_rating = rating
        show.imdb_rating_count = rating_count
        show.imdb_link = page_link
        show.save
      end
    end
    #sleep(1)
  end
end


task :get_tv_dot_com_ratings => :environment do
  require 'mechanize'

  url = "http://www.tv.com" # set url to scrape
  show = Show.individual_season_filter.remove_wikipedia_categories.where(:serialized => true).where('tv_dot_com_link IS NULL').where('show_name NOT LIKE ?', "V (2009 TV series)")
  #show = Show.individual_season_filter.remove_wikipedia_categories.where('number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1).where('tv_dot_com_rating IS NULL')
  #show = Show.where(:wikipedia_page_id => 36860986)
  show.each do |show|

    string = show.show_name
    name = string.gsub(/\(.*?\)/i,"").strip # remove description about show contained in parenthesis and unnecessary whitespace. If not done, this causes problems when searching.
    puts name
    agent = Mechanize.new # initiate a new mechanize object to hold page results
    agent.get(url) # get the root url into the mechanize object
    search_form = agent.page.form_with(:action => "/search") # find the tv.com search box using the "form_with" mechanize method.
    search_form.q = name # set the search form box to the show name. The "q" variable is the value of the search box. This is specific
                         # to tv.com and is determined by looking
    search_form.submit
    #if agent.page.at(".result.show").present?
       #node = agent.page.at(".result.show")
       #Mechanize::Page::Link.new(node, agent, page).click
    #end
    #if agent.page.link_with(:text => name).present?
    if agent.page.link_with(:text => /#{name}/i).present?
      agent.page.link_with(:text => /#{name}/i).click

      #agent = Mechanize.new
      #page = agent.get "http://google.com"
      #node = page.search ".//p[@class='posted']"
      #Mechanize::Page::Link.new(node, agent, page).click

      if agent.page.at(".score").present?
        rating = agent.page.at(".score").text.strip
        rating_count = agent.page.at("span[itemprop=ratingCount]").text.strip.gsub(/,/,"").to_i
        page_link = agent.page.uri.to_s
        puts rating
        puts rating_count
        puts page_link
        show.tv_dot_com_rating = rating
        show.tv_dot_com_rating_count = rating_count
        show.tv_dot_com_link = page_link
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