#this task copies wikipedia page ids and show names from the wikicategoryapi model to the show model.
task :copy_page_id_and_name_from_wikipediaapiquery_to_show => :environment do

  require 'rubygems'

  wikicategoryapi = WikipediaApiQuery.all
  wikicategoryapi.each do |wikicategoryapi|
     wikipedia_page_id = wikicategoryapi.wikipedia_page_id
     show = Show.find_or_create_by(:wikipedia_page_id => wikipedia_page_id)

     #this statement inserted so show_name is not constantly re-copied from wikicategoryapi.rb to show.rb
     if show.show_name == nil
       show.show_name = wikicategoryapi.show_name
     end
     show.save
     puts show.show_name
  end
end
