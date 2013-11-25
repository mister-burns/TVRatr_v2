#this task copies wikipedia page ids and show names from the wikicategoryapi model to the show model.
task :copy_page_id_and_name_from_wikipediaapiquery_to_show => :environment do

  require 'rubygems'

  wikicategoryapi = WikipediaApiQuery.all
  wikicategoryapi.each do |wikicategoryapi|
     wikipedia_page_id = wikicategoryapi.wikipedia_page_id
     show = Show.where(:wikipedia_page_id => wikipedia_page_id).first_or_create

     #this statement inserted so show_name is not constantly re-copied from wikicategoryapi.rb to show.rb
     if show.show_name == nil
       show.show_name = wikicategoryapi.show_name
     else
     end

     show.save
  end
end


#this task generates a list of all the different show attributes (genre, format, network, etc) and saves them in a table.
task :copy_show_attributes_to_show_attribute_type_model => :environment do

  require 'rubygems'

  show = Show.all
  show.each do |show|
    genre = Genre.new
    genre.genre = show.genre_1
    genre.save

    genre = Genre.new
    genre.genre = show.genre_2
    genre.save

    genre = Genre.new
    genre.genre = show.genre_3
    genre.save

    genre = Genre.new
    genre.genre = show.genre_4
    genre.save

    genre = Genre.new
    genre.genre = show.genre_5
    genre.save

    genre = Genre.new
    genre.genre = show.format_1
    genre.save

    genre = Genre.new
    genre.genre = show.format_2
    genre.save

    genre = Genre.new
    genre.genre = show.format_3
    genre.save

    genre = Genre.new
    genre.genre = show.format_4
    genre.save

    genre = Genre.new
    genre.genre = show.format_5
    genre.save

  end

end