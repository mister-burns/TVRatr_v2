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

  show = Show.individual_season_filter.remove_wikipedia_categories.where( 'number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1 )
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
        value = agent.page.at(".titlePageSprite.star-box-giga-star").text.strip
        puts value
        show.imdb_rating = value
        show.save
      end
    end
    #sleep(1)
  end
end


task :get_tv_dot_com_ratings => :environment do
  require 'mechanize'

  url = "http://www.tv.com"

  show = Show.individual_season_filter.remove_wikipedia_categories.where( 'number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1 )
  show.each do |show|

    string = show.show_name
    name = string.gsub(/\(.*?tv series.*\)/i,"").strip
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