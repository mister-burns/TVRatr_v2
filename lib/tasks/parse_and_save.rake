# This task combines all parse rake tasks and runs them together.
task :parse_all => [:parse_and_save_genre_data,
                    :parse_and_save_starring_data,
                    :parse_and_save_first_aired_data,
                    :parse_and_save_last_aired_data,
                    :parse_and_save_episode_count_data,
                    :parse_and_save_season_count_data,
                    :parse_and_save_series_count_data,
                    :parse_and_save_country_data,
                    :parse_and_save_network_data,
                    :parse_and_save_language_data
                    ] do
  puts "Everything has been parsed!"
end


task :parse_and_save_genre_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  #wikipediaapiquery = WikipediaApiQuery.where(:show_name => "Breaking Bad")
  wikipediaapiquery.each do |wikipediaapiquery|
    if wikipediaapiquery.infobox.nil?
    else
      page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
      show = Show.find_by(:wikipedia_page_id => page)
      string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
      #puts string
      #line below: remove "\n" tags and several Wikipedia phrases from string. If not removed, these items cause errors in later parsing steps.
      string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\||\{\{Plainlist\}\}|
                          \(radio and television\)|\(genre\)|\(format\)|\(fiction\)|1080i|1080p|480i|480p|hdtv|sdtv|standard-definition television|
                          standard definition television|high-definition television|high definition television|720p|url|ubl|atsc|cite web|
                          stereophonic sound|576i|stereo|\(sdtv\)|ntsc|pal|16\:9|4\:3|sd|hd/mi,"").gsub(/<\/?[^>]*>/, "|").gsub(/serial(\s|)\(radio and television\)/mi, "Serial") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
      string3 = /\b(genre|format)\s*=.*?(?=\s\|)/mi.match(string2) #search for genre string

        # the first 3 lines here help further parse the code and isolate each genre. Each show can have multiple genres.
      if string3.nil?
      else
        string4 = string3.to_s.split("=") #splits genre line at the equals sign.
        string5 = string4[1] #split from above creates an array. This code accessses the second part of the array, after the equals sign.
        # this code parses out the individual words that make up the genres.
        if string5.nil?
        else
          string6 = string5.scan(/\w+[^\|\[\]\{\}\*,](?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?/m)
          # each genre match is accessed as an array and assigned a variable.
          if string6.present?
            string6.each do |genre_string|
              genre = Genre.find_or_create_by(:name => genre_string.strip)
              puts genre.name
              genre.genre_shows.create(show_id: show.id)
            end
          end
        end
      end
    end
  end
  puts "All genre and format data parsed"
end


task :parse_and_save_starring_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  #wikipediaapiquery = WikipediaApiQuery.where(:show_name => "Breaking Bad")
  wikipediaapiquery.each do |wikipediaapiquery|
    if wikipediaapiquery.infobox.nil?
    else
      page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
      show = Show.find_by(:wikipedia_page_id => page)
      string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
      #line below: remove "\n" tags and several Wikipedia phrases from string. If not removed, these items cause errors in later parsing steps.
      string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\||\{\{Plainlist\}\}|/mi,"") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
      string3 = /\bstarring\s*=.*?(?=\s\|)/mi.match(string2) #search for genre string

      # the first 3 lines here help further parse the code and isolate each genre. Each show can have multiple genres.
      if string3.nil?
      else
        string4 = string3.to_s.split("=") #splits genre line at the equals sign.
        string5 = string4[1] #split from above creates an array. This code accessses the second part of the array, after the equals sign.
        # this code parses out the individual words that make up the genres.
        if string5.nil?
          puts string5
        else
          #string6 = string5.scan(/(?<=\[\[).*?((?=\|)|(?=\]\]))/i)
          string6 = string5.scan(/(?<=\[\[).*?(?=\]\])/i)
          # each genre match is accessed as an array and assigned a variable.
          puts show.show_name
          if string6.present?
            string6.each do |actor_string|
              actor_string2 = actor_string.split("|")
              actor_string3 = actor_string2[0]
              actor_string4 = actor_string3.gsub(/\(.+\)/,"")
              actor = Actor.find_or_create_by(:name => actor_string4.strip)
              actor.actor_shows.create(show_id: show.id)
            end
          end
        end
      end
    end
  end
  puts "All starring data parsed"
end

task :parse_and_save_first_aired_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  #wikipediaapiquery = WikipediaApiQuery.where(:wikipedia_page_id => 7759866)
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    #string2 = string.gsub(/\\n/i," ").gsub(/df=\s?(y|yes)/,"") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    #string3 = /\bfirst_aired\s*=.*?(?=\s\|)/mi.match(string2) #search for format string
    string2 = /\bfirst_aired\s*=.*?(?=(\n|\s\|))/mi.match(string)
    string3 = string2.to_s.gsub(/df=\s?(y|yes)|format=dmy/mi,"")

    #puts string
    puts string3

    # this code checks in format string is nil, in which case end variables must first get set to nil.
    if string3.nil?
      @first_aired = nil

      else
      # the first 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split(/=\s?/) #splits the string at the equals sign followed by an optional space.
      #puts string4
      string5 = string4[1] # picks the second part of the split array, the part after the equals..
      #puts string5
      if string5.nil?
        @first_aired = nil

      else
        if string5.match(/\d{4}/).present? #Check if year data is present. If yes, then remove certain characters from string.
          @first_aired = string5.gsub(/df|es|ytv\|?|nfly\|?/mi,"").gsub(/\{\{(start\s?date)|dts\|\||dts/mi,"").gsub(/\{\{|\}\}|\[\[|\]\]/mi,"").gsub(/\|MM\|DD\|/mi,"").gsub(/<!--.+--!?>|<!--|--!?>/mi,"").gsub(/<ref.*/i,"").gsub("|","/").strip
          @string = string5.gsub(/df|es|ytv\|?|nfly\|?/mi,"").gsub(/\{\{(start\s?date)|dts\|\||dts/mi,"").gsub(/\{\{|\}\}|\[\[|\]\]/mi,"").gsub(/\|MM\|DD\|/mi,"").gsub(/<!--.+--!?>|<!--|--!?>/mi,"").gsub(/<ref.*/i,"").gsub("|","/").strip.truncate(200)

        #search for last aired string in order to look for year.  If year is present, then extract and concat with month and day data.
        elsif string.match(/\blast_aired\s*=.*?(?=\n)/mi).present?
          string6 = /\blast_aired\s*=.*?(?=\n)/mi.match(string)
          puts "true"
          string7 = string6.to_s.match(/\d{4}/)
          string8 = string5.gsub(/df|es|ytv\|?|nfly\|?/mi,"").gsub(/\{\{(start\s?date)|dts\|\||dts/mi,"").gsub(/\{\{|\}\}|\[\[|\]\]/mi,"").gsub(/\|MM\|DD\|/mi,"").gsub(/<!--.+--!?>|<!--|--!?>/mi,"").gsub(/<ref.*/i,"").gsub("|","/").strip
          #puts string8
          #puts string7

          # Checks if both year and month day data are available, then concats into single string for parsing if true.
          if string8.present? && string7.present?
            #Checks if first_aired string has month name written out (/\w{3}/). If yes, concants year first, if no, concants behind.
            # switching the concantenation help produe better results with Date.parse()
            if string8.match(/\w{3}/)
              string9 = string8 + "/" + string7.to_s
            else
              string9 = string7.to_s + "/" + string8
            end
            @first_aired = string9.strip.gsub(/\/\//, "/") # strips out potential double "/" and
          end
        end
      end
    end

    puts @first_aired
    #puts @string

    #if statement to first look for dates in the "YYYY" format and add text of "/01/01" so they become Date.parse friendly
    if @first_aired =~ /^\d{4}\z/mi
      @first_aired.concat("/01/01")
    end

    #puts @first_aired

    #This test was necessary to prevent the Date.parse function from throwing an error when
    #the @string4 variable was nil. The "rescue" part sets @first_aired_match to nil if @string4 is nil.
    begin
      @first_aired_datetime = Date.parse(@first_aired)
      rescue
      @first_aired_datetime = nil
    end

    puts @first_aired_datetime

    #find the appropriate entry in the Show model and save the first aired date:
    begin
      show = Show.where(:wikipedia_page_id => page).first
      puts show.show_name
      show.first_aired_string = @string
      #puts show.first_aired_string
      show.first_aired = @first_aired_datetime
      show.save
    rescue
      show.first_aired = nil
      show.save
    end
  end
end


task :parse_and_save_last_aired_data_v2 => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  #wikipediaapiquery = WikipediaApiQuery.where(:wikipedia_page_id => 2223177)
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    #string2 = string.gsub(/\\n/i," ").gsub(/df=\s?(y|yes)/,"") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    string3 = /\blast_aired\s*=.*?(?=(\n|\s\|))/mi.match(string) #search for last aired string

    #puts string
    #puts string2
    #puts string3

    # this code checks in format string is nil, in which case end variables must last get set to nil.
    if string3.nil?
      @last_aired = nil

    else
      # the last 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split(/=\s?/) #splits the string at the equals sign followed by an optional space.
      #puts string4
      string5 = string4[1] # picks the second part of the split array, the part after the equals..
      #puts string5
      if string5.nil?
        @last_aired = nil
      else
        @last_aired = string5.gsub(/df/mi,"").gsub(/\{\{(end\s?date|dts)\|/mi,"").gsub(/\}\}/mi,"").gsub(/\|MM\|DD\|/mi,"").gsub(/<!--|--!?>|\[\[|\]\]/mi,"").gsub(/<ref>.*/i,"").gsub("|","/").strip
        @string = string5.gsub(/df/mi,"").gsub(/\{\{(end\s?date|dts)\|/mi,"").gsub(/\}\}/mi,"").gsub(/\|MM\|DD\|/mi,"").gsub(/<!--|--!?>|\[\[|\]\]/mi,"").gsub(/<ref>.*/i,"").gsub("|","/").strip.truncate(200)
      end
    end

    puts @last_aired
    #puts @string

    #if statement to last look for dates in the "YYYY" format and add text of "/01/01" so they become Date.parse friendly
    if @last_aired =~ /^\d{4}\z/mi
      @last_aired.concat("/01/01")
    elsif ( @last_aired =~ /present/mi )
      show = Show.where(:wikipedia_page_id => page).first
      show.last_aired_present = "present"
      show.save
      @last_aired = Date.today
    end

    #puts @last_aired

    #This test was necessary to prevent the Date.parse function from throwing an error when
    #the @string4 variable was nil. The "rescue" part sets @last_aired_match to nil if @string4 is nil.
    begin
      @last_aired_datetime = Date.parse(@last_aired)
    rescue
      @last_aired_datetime = nil
    end

    puts @last_aired_datetime

    #find the appropriate entry in the Show model and save the last aired date:
    begin
      show = Show.where(:wikipedia_page_id => page).first
      puts show.show_name
      #show.last_aired_string = @string
      #puts show.last_aired_string
      show.last_aired = @last_aired_datetime
      show.save
    rescue
      show.last_aired = nil
      show.save
    end
  end
end


task :parse_and_save_last_aired_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    string2 = /(last_aired\s*=\s*+)(.+?(?=\s\|))/m.match(string) #look for patterns in the data to start at first_aired and end after the date
    #take the date out of string above, substitute "/" for "|" because you cannot parse the date below without doing this
    string3 = /((\d+)\|?(\d+)\|?(\d+)|present)/mi.match(string2.to_s).to_s.gsub("|","/")

    #if statement to first look for dates in the "YYYY" format and add text of "/01/01" so they become Date.parse friendly
    if ( string3 =~ /^\d{4}\z/m )
      @string4 = string3.to_s.concat("/01/01")
    elsif ( string3 =~ /present/mi )
      show = Show.where(:wikipedia_page_id => page).first
      show.last_aired_present = "present"
      show.save
      @string4 = Date.today
    else
      @string4 = string3 #set variable to original parsed result if it is not in "YYYY" format
    end

    #This test was necessary to prevent the Date.parse function from throwing an error when...
    #...the @string4 variable was nil, then sets @first_aired_match to nil if @string4 is nil.
    begin
      @last_aired_match = Date.parse(@string4)
    rescue
      @last_aired_match = nil
    end

    #find the appropriate entry in the Show model and save the first aired date:
    show = Show.where(:wikipedia_page_id => page).first
    show.last_aired = @last_aired_match
    show.save
  end
  puts "All last aired data parsed"
end


task :parse_and_save_episode_count_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\|/mi,"").gsub(/\{\{ubl\|/mi,"").gsub(/<\/?[^>]*>/, "|") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    string3 = /\bnum_episodes\s*=.*?(?=\s\|)/mi.match(string2) #search for format string

    # this code checks in format string is nil, in which case end variables must first get set to nil.
    if string3.nil?
      @num_episodes = nil

    else
      # the first 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split("=") #takes out format and a few other words.
      string5 = string4[1] #regex used to isolate each format name.
      if string5.nil?
        @num_episodes = nil
      else
        string6 = string5.gsub(/\,/, "") # This line removes a comma when episode count is great than 1000.
        @num_episodes = string6
      end
    end

    #find the appropriate entry in the Show model and save the first aired date:
    show = Show.where(:wikipedia_page_id => page).first
    show.number_of_episodes = @num_episodes
    show.save
  end
  puts "All episode data parsed"
end


task :parse_and_save_season_count_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\|/mi,"").gsub(/\{\{ubl\|/mi,"").gsub(/<\/?[^>]*>/, "|") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    string3 = /\bnum_seasons\s*=.*?(?=\s\|)/mi.match(string2) #search for format string

    # this code checks in format string is nil, in which case end variables must first get set to nil.
    if string3.nil?
      @num_seasons = nil

    else
      # the first 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split("=") #takes out format and a few other words.
      string5 = string4[1] #regex used to isolate each format name.
      if string5.nil?
        @num_seasons = nil
      else
        string6 = string5.gsub(/\,/, "")
        @num_seasons = string6
      end
    end

    #find the appropriate entry in the Show model and save the first aired date:
    show = Show.where(:wikipedia_page_id => page).first
    show.number_of_seasons = @num_seasons
    show.save
  end
  puts "All season data parsed"
end


task :parse_and_save_series_count_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\|/mi,"").gsub(/\{\{ubl\|/mi,"").gsub(/<\/?[^>]*>/, "|") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    string3 = /\bnum_series\s*=.*?(?=\s\|)/mi.match(string2) #search for format string

    # this code checks in format string is nil, in which case end variables must first get set to nil.
    if string3.nil?
      @num_series = nil

    else
      # the first 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split("=") #takes out format and a few other words.
      string5 = string4[1] #regex used to isolate each format name.
      if string5.nil?
        @num_series = nil
      else
        string6 = string5.gsub(/\,/, "")
        @num_series = string6
      end
    end

    #find the appropriate entry in the Show model and save the first aired date:
    show = Show.where(:wikipedia_page_id => page).first
    show.number_of_series = @num_series
    show.save
  end
  puts "All series data parsed"
end


task :parse_and_save_country_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    show = Show.find_by(:wikipedia_page_id => page)
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\|/mi,"").gsub(/\{\{ubl\|/mi,"").gsub(/<\/?[^>]*>/, "|") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    string3 = /\bcountry\s*=.*?(?=\s\|)/mi.match(string2) #search for format string

    # this code checks in format string is nil, in which case end variables must first get set to nil.
    if string3.nil?
    else
      # the first 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split("=") #takes out format and a few other words.
      string5 = string4[1] #regex used to isolate each format name.
      if string5.nil?
      else
        string6 = string5.gsub(/USA|TVUS|United States of America|U\.S\.A\.|U\.S\.|\bUS/i,"United States").gsub(/Television (in|of)( the)?|\(.*\)/i,"").gsub(/flagcountry|flag|flagicon|icon|\burl|cite (news|web)|airs in the|\.|english( language)?/i,"").gsub(/\buk|tvuk|Great Britain/i,"United Kingdom").gsub(/México/i, "Mexico")
        string7 = string6.scan(/\w+[^\|\[\]\{\}\*,](?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?/m)
        string7.each do |country_string|
          #puts country_string
          #country_string2 = country_string.gsub(/\bUSA|TVUS|United States of America|U\.S\.A\.|U\.S\.|\bUS/i,"United States").gsub(/Television (in|of)( the)?|/i,"").gsub(/flagcountry|flag|flagicon|icon/i,"").gsub(/\buk/i,"United Kingdom").gsub(/México/i, "Mexico")
          country = Country.find_or_create_by(:name => country_string.strip)
          puts country.name
          country.country_shows.create(show_id: show.id)
        end
      end
    end
  end
  puts "All country data parsed"
end


task :parse_and_save_network_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    show = Show.find_by(:wikipedia_page_id => page)
    puts show.show_name
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    #line below: remove "\n" tags and several Wikipedia phrases from string. If not removed, these items cause errors in later parsing steps.
    string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\||\{\{Plainlist\}\}/mi,"").gsub(/\{\{ubl\|/mi,"").gsub(/<\/?[^>]*>/, "|")
    string3 = /\b(network|channel)\s*=.*?(?=(\n|\s\|))/mi.match(string2) #search for genre string

    # this code checks in genre string is nil, in which case end variables must first get set to nil.
    if string3.nil?
    else
      # the first 3 lines here help further parse the code and isolate each network name. Each show can have multiple genres.
      string4 = string3.to_s.split("=") #splits genre line at the equals sign.
      string5 = string4[1] #split from above creates an array. This code accessses the second part of the array, after the equals sign.
      if string5.nil?
      else
        string6 = string5.gsub(/[0-9]{4}/,"").gsub(/American Broadcasting Company|abc/i,"ABC").gsub(/Fox Broadcasting Company|fox/i,"FOX").gsub(/Columbia Broadcasting System|cbs/i,"CBS").gsub(/National Broadcasting Company|nbc/i,"NBC").gsub(/Public Broadcasting Service|pbs/i,"PBS").gsub(/home box office|hbo/i,"HBO").gsub(/\(tv channel\)|\(channel\)|\(tv network\)|cite web|/i,"")
        string7 = string6.scan(/\w+[^\|\[\]\{\}\*,](?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?/m)
        string7.each do |network_string|
          network = Network.find_or_create_by(:name => network_string.strip)
          puts network.name
          network.network_shows.create(show_id: show.id)
        end
      end
    end
  end
  puts "All network data parsed"
end


task :parse_and_save_language_data_v2 => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    show = Show.find_by(:wikipedia_page_id => page)
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\|/mi,"").gsub(/\{\{ubl\|/mi,"").gsub(/<\/?[^>]*>/, "|") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    string3 = /\blanguage\s*=.*?(?=\s\|)/mi.match(string2) #search for format string

    # this code checks in format string is nil, in which case end variables must first get set to nil.
    if string3.nil?
    else
      # the first 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split("=") #takes out format and a few other words.
      string5 = string4[1] #regex used to isolate each format name.
      if string5.nil?
      else
        string6 = string5.gsub(/american english|australian english|U\.?S\.? english|british english|scottish english|english/i,"English").gsub(/language|\(.*\)|\.|subtitle|cite news|citeweb|url|nowrap/i,"").gsub(/quebec french/i,"French")
        string7 = string6.scan(/\w+[^\|\[\]\{\}\*,](?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?/m)
        string7.each do |language_string|
          language_string2 = language_string.split("/")
          language = Language.find_or_create_by(:name => language_string2[0].strip)
          puts language.name
          language.language_shows.create(show_id: show.id)
        end
      end
    end
  end
  puts "All language data parsed"
end

task :parse_and_save_language_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\|/mi,"").gsub(/\{\{ubl\|/mi,"").gsub(/<\/?[^>]*>/, "|") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    string3 = /\blanguage\s*=.*?(?=\s\|)/mi.match(string2) #search for format string

    # this code checks in format string is nil, in which case end variables must first get set to nil.
    if string3.nil?
      @language = nil

    else
      # the first 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split("=") #takes out format and a few other words.
      string5 = string4[1] #regex used to isolate each format name.
        if string5.nil?
          @language = nil
        else
          string6 = string5.scan(/\w+[^\|\[\]\{\}\*,](?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?/m)
          @language = string6[0]
        end
    end

    #find the appropriate entry in the Show model and save the first aired date:
    show = Show.where(:wikipedia_page_id => page).first
    show.language = @language
    show.save
  end
  puts "All language data parsed"
end


task :delete_first_aired_strings => :environment do
  show = Show.all
  show.each do |show|
    show.first_aired_string = nil
    show.save
  end
end