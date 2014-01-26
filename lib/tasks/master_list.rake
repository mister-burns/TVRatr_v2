# This master rake file conducts all rake tasks in order:
# First, in ":query_active_categories" all active wikipedia categories that will contain new shows are queried for members.
# Second, in ":infobox_query_from_wikipedia_page_id" each show entry in the WikipediaApiQuery.rb model is used to query wikipedia for the show's infobox
# Third, in ":copy_page_id_and_name_from_wikipediaapiquery_to_show", the show names and wikipedia ID numbers are copied from the WikipediaApiQuery model to the Show model.
# Fourth,in ":parse_all", the infobox is parsed for show details which are saved to attributes in the Show.rb model.

task :master_rake => [:wikipedia_rake,
                      :rakings_rake
] do
  puts "All rakes complete!"
end

task :wikipedia_rake => [:query_all_categories,
                         :new_shows_infobox_query,
                         :active_shows_infobox_query,
                         :copy_page_id_and_name_from_wikipediaapiquery_to_show,
                         :parse_all
] do
  puts "Wikipedia rakes complete!"
end

task :ratings_rake => [:get_imdb_ratings,
                       :get_tv_dot_com_ratings,
                       :get_metacritic_ratings,
                       :get_itunes_availability
] do
  puts "Ratings rakes complete!"
end