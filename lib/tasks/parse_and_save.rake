# This task combines all parse rake tasks and runs them together.
task :parse_all => [:parse_and_save_genre_data,
                    :parse_and_save_format_data,
                    :parse_and_save_first_aired_data_v2,
                    :parse_and_save_last_aired_data,
                    :parse_and_save_episode_count_data,
                    :parse_and_save_season_count_data,
                    :parse_and_save_series_count_data_v2,
                    :parse_and_save_country_data,
                    :parse_and_save_network_data,
                    :parse_and_save_language_data
                    ] do
  puts "Everything has been parsed!"
end


task :parse_and_save_genre_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  #wikipediaapiquery = WikipediaApiQuery.where(:show_name => "Category:Thunderbirds (TV series)")
  wikipediaapiquery.each do |wikipediaapiquery|
    if wikipediaapiquery.infobox.nil?
      else
      page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
      string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
      #puts string
      #line below: remove "\n" tags and several Wikipedia phrases from string. If not removed, these items cause errors in later parsing steps.
      string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\||\{\{Plainlist\}\}|
                          \(radio and television\)|\(genre\)|\(format\)|\(fiction\)|1080i|1080p|480i|480p|hdtv|sdtv|standard-definition television|
                          standard definition television|high-definition television|high definition television|720p|url|ubl|atsc|cite web|
                          stereophonic sound|576i|stereo|\(sdtv\)|ntsc|pal|16\:9|4\:3|sd|hd/mi,"").gsub(/<\/?[^>]*>/, "|").gsub(/serial(\s|)\(radio and television\)/mi, "Serial") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
      string3 = /\bgenre\s*=.*?(?=\s\|)/mi.match(string2) #search for genre string

      # this code checks in genre string is nil, in which case end variables must first get set to nil.
      if string3.nil?
        @genre1 = nil
        @genre2 = nil
        @genre3 = nil
        @genre4 = nil
        @genre5 = nil
      else
        # the first 3 lines here help further parse the code and isolate each genre. Each show can have multiple genres.
        string4 = string3.to_s.split("=") #splits genre line at the equals sign.
        string5 = string4[1] #split from above creates an array. This code accessses the second part of the array, after the equals sign.
        if string5.nil?
          @genre1 = nil
          @genre2 = nil
          @genre3 = nil
          @genre4 = nil
          @genre5 = nil
        else
          # this code parses out the individual words that make up the genres.
          string6 = string5.scan(/\w+[^\|\[\]\{\}\*,](?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?/m)
          # each genre match is accessed as an array and assigned a variable.
          @genre1 = string6[0]
          @genre2 = string6[1]
          @genre3 = string6[2]
          @genre4 = string6[3]
          @genre5 = string6[4]
        end
      end

      #find the appropriate entry in the Show model and save the genre variables:
      show = Show.where(:wikipedia_page_id => page).first
      show.genre_1 = @genre1
      show.genre_2 = @genre2
      show.genre_3 = @genre3
      show.genre_4 = @genre4
      show.genre_5 = @genre5
      show.save
      puts show.show_name
    end
  end
    puts "All genre data parsed"
end


task :parse_and_save_format_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    #line below: remove "\n" tags and several Wikipedia phrases from string. If not removed, these items cause errors in later parsing steps.
    string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\||\{\{Plainlist\}\}
                          |\(genre\)|\(format\)|\(fiction\)|1080i|1080p|480i|480p|hdtv|sdtv|standard-definition television|
                          standard definition television|high-definition television|high definition television|720p|url|ubl|atsc|cite web|
                          stereophonic sound|576i|stereo|\(sdtv\)|ntsc|pal|16\:9|4\:3|sd|hd/mi,"").gsub(/<\/?[^>]*>/, "|").gsub(/serial(\s|)\(radio and television\)/mi, "Serial") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    string3 = /\bformat\s*=.*?(?=\s\|)/mi.match(string2) #search for format string

    # this code checks in format string is nil, in which case end variables must first get set to nil.
    if string3.nil?
      @format1 = nil
      @format2 = nil
      @format3 = nil
      @format4 = nil
      @format5 = nil
    else
      # the first 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split("=") #splits format line at the equals sign.
      string5 = string4[1] #split from above creates an array. This code accessses the second part of the array, after the equals sign.
      if string5.nil?
        @format1 = nil
        @format2 = nil
        @format3 = nil
        @format4 = nil
        @format5 = nil
      else
        # this code parses out the individual words that make up the formats.
        string6 = string5.scan(/\w+[^\|\[\]\{\}\*,](?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?/m)
        # each format match is accessed as an array and assigned a variable.
        @format1 = string6[0]
        @format2 = string6[1]
        @format3 = string6[2]
        @format4 = string6[3]
        @format5 = string6[4]
      end
    end

    #find the appropriate entry in the Show model and save the format variables:
    show = Show.where(:wikipedia_page_id => page).first
    show.format_1 = @format1
    show.format_2 = @format2
    show.format_3 = @format3
    show.format_4 = @format4
    show.format_5 = @format5
    show.save
    puts show.show_name
  end
  puts "All format data parsed"
end


task :parse_and_save_first_aired_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash. The "first" part is necessary when has reaches an array.
    string2 = /(first_aired\s*=\s*+)(.+?(?=\s\|))/m.match(string) #look for patterns in the data to start at first_aired and end after the date
    #take the date out of string above, substitute "/" for "|" because you cannot parse the date below without doing this
    string3 = /(\d+)\|?(\d+)\|?(\d+)/m.match(string2.to_s).to_s.gsub("|","/")

    #if statement to first look for dates in the "YYYY" format and add text of "/01/01" so they become Date.parse friendly
    if ( string3 =~ /^\d{4}\z/m )
      @string4 = string3.to_s.concat("/01/01")
    else
      @string4 = string3 #set variable to original parsed result if it is not in "YYYY" format and thus already convetable to a date.
    end

    #This test was necessary to prevent the Date.parse function from throwing an error when
    #the @string4 variable was nil. The "rescue" part sets @first_aired_match to nil if @string4 is nil.
    begin
      @first_aired_match = Date.parse(@string4)
    rescue
      @first_aired_match = nil
    end

    #find the appropriate entry in the Show model and save the first aired date:
    show = Show.where(:wikipedia_page_id => page).first
    show.first_aired = @first_aired_match
    show.save
  end
  puts "All first aired data parsed"
end


task :parse_and_save_first_aired_data_v2 => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    string2 = string.gsub(/\\n/i," ").gsub(/df=\s?(y|yes)/,"") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    string3 = /\bfirst_aired\s*=.*?(?=\s\|)/mi.match(string2) #search for format string

    #puts string2
    #puts string3

    # this code checks in format string is nil, in which case end variables must first get set to nil.
    if string3.nil?
      @first_aired = nil

      else
      # the first 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split(/=\s?/) #splits the string at the equals sign followed by an optional space.
      #puts string4
      string5 = string4[1] # picks the second part of the split array, the part after the equals..
      if string5.nil?
        @first_aired = nil
        else
        @first_aired = string5.gsub(/df|es/mi,"").gsub(/\{\{(start date|dts)\|/mi,"").gsub(/\}\}/mi,"").gsub(/\|MM\|DD\|/mi,"").gsub(/<!--|--!?>/mi,"").gsub("|","/").strip
        @string = string5.gsub(/df|es/mi,"").gsub(/\{\{(start date|dts)\|/mi,"").gsub(/\}\}/mi,"").gsub(/\|MM\|DD\|/mi,"").gsub(/<!--|--!?>/mi,"").gsub("|","/").strip.truncate(200)
        end
    end

    #puts @first_aired

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

    puts "hello"
    #puts @first_aired_datetime
    #puts @string

    #find the appropriate entry in the Show model and save the first aired date:
    show = Show.where(:wikipedia_page_id => page).first
    puts show.show_name
    show.first_aired_string = @string
    #puts show.first_aired_string
    show.first_aired = @first_aired_datetime
    show.save
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


task :parse_and_save_series_count_data_v2 => :environment do
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


#This task parses the num_series infobox value. Num_series is sometimes used instead of num_seasons,
#especially for UK shows.
task :parse_and_save_series_count_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    series_match = /(?:num_series\s*=\s*)([0-9]+)/m.match(string) #look for patterns in the data to start at num_series and end at the last date digit of the number

    #run an if statement to weed out nil data, so I can call the match grouping in the else statement
    if series_match.nil?
      @series_value = nil
    else
      @series_value = series_match[1] #set series value to second group of the match data
    end

    #Call the show model object where the wikipedia ID matches the page number of the JSON we just parsed.
    show = Show.where(:wikipedia_page_id => page).first
    show.number_of_series = @series_value
    show.save
  end
end


task :parse_and_save_country_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\|/mi,"").gsub(/\{\{ubl\|/mi,"").gsub(/<\/?[^>]*>/, "|") #remove "\n" tags from string. If not removed, these tags cause errors in later parsing steps.
    string3 = /\bcountry\s*=.*?(?=\s\|)/mi.match(string2) #search for format string

    # this code checks in format string is nil, in which case end variables must first get set to nil.
    if string3.nil?
      @country_1 = nil
      @country_2 = nil
      @country_3 = nil
    else
      # the first 3 lines here help further parse the code and isolate each format. Each show can have multiple formats.
      string4 = string3.to_s.split("=") #takes out format and a few other words.
      string5 = string4[1] #regex used to isolate each format name.
      if string5.nil?
        @country_1 = nil
        @country_2 = nil
        @country_3 = nil
      else
        string6 = string5.gsub(/USA|TVUS|United States of America/i,"United States").gsub(/Television (in|of) the/i,"").gsub(/flagcountry|flag|flagicon|icon/i,"")
        string7 = string6.scan(/\w+[^\|\[\]\{\}\*,](?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?/m)
        @country_1 = string7[0]
        @country_2 = string7[1]
        @country_3 = string7[2]
      end
    end


    #find the appropriate entry in the Show model and save the first aired date:
    show = Show.where(:wikipedia_page_id => page).first
    show.country_1 = @country_1
    show.country_2 = @country_2
    show.country_3 = @country_3
    show.save
  end
  puts "All country data parsed"
end

task :parse_and_save_network_data => :environment do
  wikipediaapiquery = WikipediaApiQuery.all
  wikipediaapiquery.each do |wikipediaapiquery|
    page = wikipediaapiquery.wikipedia_page_id  # set page variable to help parse JSON hash in next line
    string = JSON.parse(wikipediaapiquery.infobox)["query"]["pages"]["#{page}"]["revisions"].first["*"] #parse JSON hash
    #line below: remove "\n" tags and several Wikipedia phrases from string. If not removed, these items cause errors in later parsing steps.
    string2 = string.gsub(/\\n/i," ").gsub(/\{\{Plainlist \||\{\{Unbulleted list\||\{\{Plainlist\||\{\{Plainlist\}\}/mi,"").gsub(/\{\{ubl\|/mi,"").gsub(/<\/?[^>]*>/, "|")
    string3 = /\b(network|channel)\s*=.*?(?=\s\|)/mi.match(string2) #search for genre string

    # this code checks in genre string is nil, in which case end variables must first get set to nil.
    if string3.nil?
      @genre1 = nil
      @genre2 = nil
    else
      # the first 3 lines here help further parse the code and isolate each genre. Each show can have multiple genres.
      string4 = string3.to_s.split("=") #splits genre line at the equals sign.
      string5 = string4[1] #split from above creates an array. This code accessses the second part of the array, after the equals sign.
      if string5.nil?
        @genre1 = nil
        @genre2 = nil
      else
        # this code parses out the individual words that make up the genres.
        string6 = string5.gsub(/[0-9]{4}/,"").gsub(/American Broadcasting Company/im,"ABC").gsub(/Fox Broadcasting Company/im,"FOX").gsub(/Columbia Broadcasting System/im,"CBS").gsub(/National Broadcasting Company/im,"NBC").gsub(/Public Broadcasting Service/im,"PBS").gsub(/home box office/im,"HBO")
        string7 = string6.scan(/\w+[^\|\[\]\{\}\*,](?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?(?:\w*[^\|\[\]\{\}\*,])?/m)
        # each genre match is accessed as an array and assigned a variable.
        @network1 = string7[0]
        @network2 = string7[1]
      end
    end

    #find the appropriate entry in the Show model and save the genre variables:
    show = Show.where(:wikipedia_page_id => page).first
    show.network_1 = @network1
    show.network_2 = @network2
    show.save
  end
  puts "All network data parsed"
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