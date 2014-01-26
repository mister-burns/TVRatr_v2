# this task takes each wikipedia page number from wikipedia_api_query.rb model and runs a query against the
# wikipedia API to return the infobox data.  The infobox data is then saved into the wikipedia_api_query.infobox
# this task needs to performed AFTER each of the category list queries have been completed.
# to run query on shows just added (to save time) set wikipediaapiquery equal to: WikipediaApiQuery.where("created_at >= ?", Time.zone.now.beginning_of_day)

task :new_shows_infobox_query => :environment do
  require 'rubygems'
  require 'json'
  require 'net/http'

  wikipediaapiquery = WikipediaApiQuery.where("created_at >= ?", Time.zone.now.beginning_of_day)
  #wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    if wikipediaapiquery.wikipedia_page_id.nil?
    else
      query = wikipediaapiquery.wikipedia_page_id
      #this is the wiki article numbers version
      $wikipediaAPI = "http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=#{query}&prop=revisions&rvprop=content&rvsection=0"
      response = Net::HTTP.get_response(URI.parse($wikipediaAPI))
      data = response.body
      #note: no JSON parsing is done here...that happens in parsing code in other rake tasks
      if data.nil?
      else
        #save data to table
        wikipediaapiquery.infobox = data
        wikipediaapiquery.save
        puts wikipediaapiquery.show_name
      end
      #puts wikipediaapiquery.infobox
    end
  end
  puts "All Infoboxes have been queried"
end


task :active_shows_infobox_query => :environment do
  require 'rubygems'
  require 'json'
  require 'net/http'

  show = Show.where('last_aired > ? OR first_aired > ? OR last_aired_present = ?', "#{2.years.ago}", "#{2.years.ago}", "present" )
  show.each do |show|
    query = show.wikipedia_page_id
    wikipediaapiquery = WikipediaApiQuery.find_by_wikipedia_page_id(show.wikipedia_page_id)
    #this is the wiki article numbers version
    $wikipediaAPI = "http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=#{query}&prop=revisions&rvprop=content&rvsection=0"
    response = Net::HTTP.get_response(URI.parse($wikipediaAPI))
    data = response.body
    #note: no JSON parsing is done here...that happens in parsing code in other rake tasks
    if data.nil?
    else
      #save data to table
      wikipediaapiquery.infobox = data
      wikipediaapiquery.save
      puts wikipediaapiquery.show_name
    end
    #puts wikipediaapiquery.infobox
  end
  puts "All Infoboxes have been queried"
end