task :get_imdb_ratings => :environment do
  require 'mechanize'

  url = "http://www.imdb.com"
  date = Date.new(2013,6,1)
  show = Show.individual_season_filter.remove_wikipedia_categories.where(:serialized => true).where('amazon_instant_availability IS NULL')
  #show = Show.individual_season_filter.remove_wikipedia_categories.where('amazon_instant_availability IS NULL').where('first_aired > ?', date)
  #show = Show.where(:wikipedia_page_id => 38411152)
  #show = Show.individual_season_filter.remove_wikipedia_categories.where('number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1)
  #show = Show.individual_season_filter.remove_wikipedia_categories.where( 'number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1 ).where('imdb_rating IS NULL')
  show.each do |show|

    string = show.show_name
    name = string.gsub(/\(.*?\)|\*/i,"").strip
    puts name
    agent = Mechanize.new
    agent.get(url)
    search_form = agent.page.form_with(:action => "/find")
    search_form.q = name
    search_form.s = "tt" # This sets the search option to look for titles only. It helps narrow the results more precisely.
    search_form.submit

    if agent.page.link_with(:text => /#{name}/i).present?
      agent.page.link_with(:text => /#{name}/i).click

      # find rating and save to data table.
      if agent.page.at(".titlePageSprite.star-box-giga-star").present?
        rating = agent.page.at(".titlePageSprite.star-box-giga-star").text.strip
        if agent.page.at("span[itemprop=ratingCount]").present? then rating_count = agent.page.at("span[itemprop=ratingCount]").text.strip.gsub(/,/,"").to_i end
        page_link = agent.page.uri.to_s
        puts rating
        puts rating_count
        show.imdb_rating = rating
        show.imdb_rating_count = rating_count
        show.imdb_link = page_link
        show.save
      end

      # This code checks for amazon instant availability and own availability and then saves links in model.
      if agent.page.search('div.watch-bar a').present? # looks for watch-bar div links, which contain watch now link and show instant video availability
        agent.page.search('div.watch-bar a').each do |test|
          if test.css('h3').text.match(/watch now/i) && test.css('p').text.match(/amazon|prime/i)
            relative_link = test[:href] # find relative link to watch now
            absolute_link = url + "#{relative_link}" # combine relative link and base url for absolute url
            agent.get(absolute_link) # put absolute url into new mechanize object
            page_link = agent.page.uri.to_s #set value for new absolute page link from mechanize object
            puts page_link
            show.amazon_instant_availability = page_link
            show.save
          elsif test.css('h3').text.match(/own it/i) && test.css('p').text.match(/amazon\.com/i)
            puts "own match"
            relative_link = test[:href] # find relative link to own option on amazon
            absolute_link = url + "#{relative_link}" # combine relative link and base url for absolute url
            agent.get(absolute_link) # put absolute url into new mechanize object
            page_link = agent.page.uri.to_s
            puts page_link
            show.amazon_own_availability = page_link
            show.save
          end
        end
      end

    end
  end
end


task :get_tv_dot_com_ratings => :environment do
  require 'mechanize'

  url = "http://www.tv.com" # set url to scrape
  date = Date.new(2013,6,1)
  show = Show.individual_season_filter.remove_wikipedia_categories.where(:serialized => true).where('tv_dot_com_rating IS NULL')
  #show = Show.individual_season_filter.remove_wikipedia_categories.where('number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1).where('show_name NOT LIKE ?', "V (2009 TV series)").where('tv_dot_com_rating IS NULL').where('first_aired > ?', date)
  #show = Show.individual_season_filter.remove_wikipedia_categories.where('number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1).where('tv_dot_com_rating IS NULL')
  #show = Show.where(:wikipedia_page_id => 38411152)
  show.each do |show|

    string = show.show_name
    name = string.gsub(/\(.*?\)|\*/i,"").strip # remove description about show contained in parenthesis and unnecessary whitespace. If not done, this causes problems when searching.
    puts name
    agent = Mechanize.new # initiate a new mechanize object to hold page results
    agent.get(url) # get the root url into the mechanize object
    search_form = agent.page.form_with(:action => "/search") # find the tv.com search box using the "form_with" mechanize method.
    search_form.q = name # set the search form box to the show name. The "q" variable is the value of the search box. This is specific
                         # to tv.com and is determined by looking
    search_form.submit

    if agent.page.link_with(:text => /#{name}/i).present?
      agent.page.link_with(:text => /#{name}/i).click

      if agent.page.at(".score").present?
        rating = agent.page.at(".score").text.strip
        if agent.page.at("span[itemprop=ratingCount]").present? then rating_count = agent.page.at("span[itemprop=ratingCount]").text.strip.gsub(/,/,"").to_i end
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

  url = "http://www.metacritic.com/"
  date = Date.new(2013,6,1)
  show = Show.individual_season_filter.remove_wikipedia_categories.where(:serialized => true)
  #show = Show.individual_season_filter.remove_wikipedia_categories.where('metacritic_rating IS NULL').where('first_aired > ?', date).reverse_order
  #show = Show.where(:wikipedia_page_id => 38411152)
  show.each do |show|

    string = show.show_name
    name = string.gsub(/\(.*?\)/i,"").gsub(/%|\//,"").strip

    puts name
    agent = Mechanize.new
    agent.get(url)
    search_form = agent.page.form_with(:action => "/search")
    search_form.search_term = name
    search_form.submit
    name2 = name.gsub("*","\\*") # input slash in front of regex special characters that throw off search in line below

    # Search for and click on link to TV Shows in search box. This helps narrow results to only TV shows.
    if agent.page.link_with(:text => /TV Shows/).present?
      agent.page.link_with(:text => /TV Shows/).click

      # Click on link of TV-only search results where name of show is in text...this needs improvement.
      if agent.page.link_with(:text => /#{name2}/i).present?
        agent.page.link_with(:text => /#{name2}/i).click

        # This finds the rating and saves it into an array value.
        if agent.page.at("span[itemprop=ratingValue]").present?
          value = agent.page.at("span[itemprop=ratingValue]").text.strip
          page_link = agent.page.uri.to_s
          @array = Array.new # create new array to hold values for each season.
          @array << value.to_f
          show.metacritic_link = page_link

          # This if statement looks for links to other seasons, which are kept in a specific div class.
          # Use .search method to find "summary_detail product_seasons" li class, then "a" to capture all links in a Nokogiri object
          if agent.page.search('.summary_detail.product_seasons a').present?
            agent.page.search('.summary_detail.product_seasons a').each do |link| # Iterate over each nokogiri link object
              url2 = url + "#{link["href"]}" # create a new URL for each season
              agent.get(url2) # use mechanize to get mechanize object (webpage) for each season

              if agent.page.at("span[itemprop=ratingValue]").present? # test if the rating is present?
                value = agent.page.at("span[itemprop=ratingValue]").text.strip
                @array << value.to_f # be sure to set value captured to a floating class number
              end
            end
          end

          # Save value to data table and derive average rating for all seasons.
          puts @array
          show.metacritic_rating = @array # set metacritic_rating variable to array of each season rating
          average = @array.inject{ |sum, el| sum + el }.to_f / @array.size # average out values of array using inject method
          puts average
          show.metacritic_average_rating = average # set metacritic_average_rating to the average of each season value captured.
          show.save

        # This else code used to capture "Show Not Yet Rated" text, if present. It only comes into play if NO seasons have ratings.
        else
          if agent.page.at('.summary').present?
            if agent.page.at('.summary').at('.desc').present?
              value = agent.page.at('.summary').at('.desc').text.strip
              show.metacritic_rating = value
              show.save
              puts value
            end
          end
        end
      end
    end
  end
end

# This currently checks availability and gets a link. Rating data did not seem to be available...need to check more.
task :get_itunes_availability => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  show = Show.individual_season_filter.remove_wikipedia_categories.where('itunes_link IS NULL')
  #show = Show.individual_season_filter.remove_wikipedia_categories.where('number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1)
  #show = Show.individual_season_filter.remove_wikipedia_categories.where(:serialized => true).where('metacritic_rating IS NULL')
  #show = Show.where(:wikipedia_page_id => 38411152)

  show.each do |show|
    string = show.show_name
    query = string.gsub(/\(.*?\)/i,"").gsub(/%|\//,"").strip
    $itunesAPI = "https://itunes.apple.com/search?term=#{URI.escape(query)}&entity=tvShow"
    response = Net::HTTP.get_response(URI.parse($itunesAPI))
    data = response.body
    hash = JSON.parse(data)
    if hash["results"].present?
      show.itunes_link = hash["results"].first["artistLinkUrl"]
      puts hash["results"].first["artistLinkUrl"]
      show.save
    end
  end
end


task :get_hulu_availability => :environment do
  require 'mechanize'

  url = "http://www.hulu.com/search" # set url to scrape
  #show = Show.individual_season_filter.remove_wikipedia_categories.where('number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1).where('show_name NOT LIKE ?', "V (2009 TV series)").where('tv_dot_com_rating IS NULL').reverse_order
  #show = Show.individual_season_filter.remove_wikipedia_categories.where('number_of_seasons >= ? AND number_of_episodes >= ?', 1, 1).where('tv_dot_com_rating IS NULL')
  show = Show.where(:wikipedia_page_id => 187586)
  show.each do |show|

    string = show.show_name
    name = string.gsub(/\(.*?\)|\*/i,"").strip
    puts name
    agent = Mechanize.new
    agent.get(url)
    puts agent.page
    #search_form = agent.page.form_with(:action => "/search")
    #puts search_form
    #search_form.q = name
    #search_form.submit

    puts agent.page
  end

end