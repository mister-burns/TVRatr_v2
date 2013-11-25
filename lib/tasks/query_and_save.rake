#this task takes each wikipedia page number from wikipedia_api_query.rb model and runs a query against the
#wikipedia API to return the infobox data.  The infobox data is then saved into the wikipedia_api_query.infobox
#this task needs to performed AFTER each of the category list queries have been completed.
task :infobox_query_from_wikipedia_page_id => :environment do
  require 'rubygems'
  require 'json'
  require 'net/http'

  wikipediaapiquery = WikipediaApiQuery.all
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
      end
      puts wikipediaapiquery.infobox
    end
  end
end


#This task queries from the "English-language_television_programming" category list.
task :category_query_english_language_television_programming => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  @query = "English-language_television_programming"
  #this is the version to query a list of wikipedia entries by category. Deliver JSON with 500 item limit.
  #Need to combine key (the cmcontinue code) from results to continuation to get full list.
  $wikicategoryAPI = "https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500"
  response = Net::HTTP.get_response(URI.parse($wikicategoryAPI))
  data = response.body
  hash = JSON.parse(data)
  hash2 = hash["query"]["categorymembers"] #these hash key are what wikipedia uses to set up category lists.

  #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
  #the cmcontinue variable is set.  If not, it is set to stop on the next loop
  if hash.key?("query-continue")
    @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"] #this has key is used by wikipedia to pass a code for continuation of queries more than 500 results long.
  else
    @cmcontinue = "stop"
  end

  hash2.each do |hash2|
    show = WikipediaApiQuery.new
    show.wikipedia_page_id = hash2["pageid"]
    show.show_name = hash2["title"]
    show.save
  end

  #set while loop to keep querying category continuation until cmcontinue = nil or 50 attempts (30000 entries)
  #put in count condition to limit number of loops in case query returns change and cmco
  count = 0
  while @cmcontinue != "stop" && count < 50 do
     count = count + 1
     $cmcontinueAPI = URI.encode("https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500&cmcontinue=#{@cmcontinue}")
     response = Net::HTTP.get_response(URI.parse($cmcontinueAPI))
     data = response.body
     hash = JSON.parse(data)
     hash2 = hash["query"]["categorymembers"]

       #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
       #the cmcontinue variable is set.  If not, it is set to stop on the next loop
       if hash.key?("query-continue")
         @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"]
       else
         @cmcontinue = "stop"
       end

     hash2.each do |hash2|
       show = WikipediaApiQuery.new
       show.wikipedia_page_id = hash2["pageid"]
       show.show_name = hash2["title"]
       show.save
     end
  end
end


#This task queries from the "Serial_drama_television_series" category list.
task :category_query_serial_drama_television_series => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  @query = "Serial_drama_television_series"
  #this is the version to query a list of wikipedia entries by category. Deliver JSON with 500 item limit.
  #Need to combine key (the cmcontinue code) from results to continuation to get full list.
  $wikicategoryAPI = "https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500"
  response = Net::HTTP.get_response(URI.parse($wikicategoryAPI))
  data = response.body
  hash = JSON.parse(data)
  hash2 = hash["query"]["categorymembers"] #these hash key are what wikipedia uses to set up category lists.

  #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
  #the cmcontinue variable is set.  If not, it is set to stop on the next loop
  if hash.key?("query-continue")
    @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"] #this has key is used by wikipedia to pass a code for continuation of queries more than 500 results long.
  else
    @cmcontinue = "stop"
  end

  hash2.each do |hash2|
    show = WikipediaApiQuery.new
    show.wikipedia_page_id = hash2["pageid"]
    show.show_name = hash2["title"]
    show.save
  end

  #set while loop to keep querying category continuation until cmcontinue = nil or 50 attempts (30000 entries)
  #put in count condition to limit number of loops in case query returns change and cmco
  count = 0
  while @cmcontinue != "stop" && count < 50 do
    count = count + 1
    $cmcontinueAPI = URI.encode("https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500&cmcontinue=#{@cmcontinue}")
    response = Net::HTTP.get_response(URI.parse($cmcontinueAPI))
    data = response.body
    hash = JSON.parse(data)
    hash2 = hash["query"]["categorymembers"]

    #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
    #the cmcontinue variable is set.  If not, it is set to stop on the next loop
    if hash.key?("query-continue")
      @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"]
    else
      @cmcontinue = "stop"
    end

    hash2.each do |hash2|
      show = WikipediaApiQuery.new
      show.wikipedia_page_id = hash2["pageid"]
      show.show_name = hash2["title"]
      show.save
    end
  end
end

#This task queries from the "British_drama_television_series" category list.
task :category_query_british_drama_television_series => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  @query = "British_drama_television_series"
  #this is the version to query a list of wikipedia entries by category. Deliver JSON with 500 item limit.
  #Need to combine key (the cmcontinue code) from results to continuation to get full list.
  $wikicategoryAPI = "https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500"
  response = Net::HTTP.get_response(URI.parse($wikicategoryAPI))
  data = response.body
  hash = JSON.parse(data)
  hash2 = hash["query"]["categorymembers"] #these hash key are what wikipedia uses to set up category lists.

  #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
  #the cmcontinue variable is set.  If not, it is set to stop on the next loop
  if hash.key?("query-continue")
    @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"] #this has key is used by wikipedia to pass a code for continuation of queries more than 500 results long.
  else
    @cmcontinue = "stop"
  end

  hash2.each do |hash2|
    show = WikipediaApiQuery.new
    show.wikipedia_page_id = hash2["pageid"]
    show.show_name = hash2["title"]
    show.save
  end

  #set while loop to keep querying category continuation until cmcontinue = nil or 50 attempts (30000 entries)
  #put in count condition to limit number of loops in case query returns change and cmco
  count = 0
  while @cmcontinue != "stop" && count < 50 do
    count = count + 1
    $cmcontinueAPI = URI.encode("https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500&cmcontinue=#{@cmcontinue}")
    response = Net::HTTP.get_response(URI.parse($cmcontinueAPI))
    data = response.body
    hash = JSON.parse(data)
    hash2 = hash["query"]["categorymembers"]

    #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
    #the cmcontinue variable is set.  If not, it is set to stop on the next loop
    if hash.key?("query-continue")
      @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"]
    else
      @cmcontinue = "stop"
    end

    hash2.each do |hash2|
      show = WikipediaApiQuery.new
      show.wikipedia_page_id = hash2["pageid"]
      show.show_name = hash2["title"]
      show.save
    end
  end
end


#This task queries from the "2010s_American_television_series" category list.
task :category_query_2010s_American_television_series => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  @query = "2010s_American_television_series"
  #this is the version to query a list of wikipedia entries by category. Deliver JSON with 500 item limit.
  #Need to combine key (the cmcontinue code) from results to continuation to get full list.
  $wikicategoryAPI = "https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500"
  response = Net::HTTP.get_response(URI.parse($wikicategoryAPI))
  data = response.body
  hash = JSON.parse(data)
  hash2 = hash["query"]["categorymembers"] #these hash key are what wikipedia uses to set up category lists.

  #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
  #the cmcontinue variable is set.  If not, it is set to stop on the next loop
  if hash.key?("query-continue")
    @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"] #this has key is used by wikipedia to pass a code for continuation of queries more than 500 results long.
  else
    @cmcontinue = "stop"
  end

  hash2.each do |hash2|
    show = WikipediaApiQuery.new
    show.wikipedia_page_id = hash2["pageid"]
    show.show_name = hash2["title"]
    show.save
  end

  #set while loop to keep querying category continuation until cmcontinue = nil or 50 attempts (30000 entries)
  #put in count condition to limit number of loops in case query returns change and cmco
  count = 0
  while @cmcontinue != "stop" && count < 50 do
    count = count + 1
    $cmcontinueAPI = URI.encode("https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500&cmcontinue=#{@cmcontinue}")
    response = Net::HTTP.get_response(URI.parse($cmcontinueAPI))
    data = response.body
    hash = JSON.parse(data)
    hash2 = hash["query"]["categorymembers"]

    #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
    #the cmcontinue variable is set.  If not, it is set to stop on the next loop
    if hash.key?("query-continue")
      @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"]
    else
      @cmcontinue = "stop"
    end

    hash2.each do |hash2|
      show = WikipediaApiQuery.new
      show.wikipedia_page_id = hash2["pageid"]
      show.show_name = hash2["title"]
      show.save
    end
  end
end


#This task queries from the "2000s_American_television_series" category list.
task :category_query_2000s_American_television_series => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  @query = "2000s_American_television_series"
  #this is the version to query a list of wikipedia entries by category. Deliver JSON with 500 item limit.
  #Need to combine key (the cmcontinue code) from results to continuation to get full list.
  $wikicategoryAPI = "https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500"
  response = Net::HTTP.get_response(URI.parse($wikicategoryAPI))
  data = response.body
  hash = JSON.parse(data)
  hash2 = hash["query"]["categorymembers"] #these hash key are what wikipedia uses to set up category lists.

  #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
  #the cmcontinue variable is set.  If not, it is set to stop on the next loop
  if hash.key?("query-continue")
    @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"] #this has key is used by wikipedia to pass a code for continuation of queries more than 500 results long.
  else
    @cmcontinue = "stop"
  end

  hash2.each do |hash2|
    show = WikipediaApiQuery.new
    show.wikipedia_page_id = hash2["pageid"]
    show.show_name = hash2["title"]
    show.save
  end

  #set while loop to keep querying category continuation until cmcontinue = nil or 50 attempts (30000 entries)
  #put in count condition to limit number of loops in case query returns change and cmco
  count = 0
  while @cmcontinue != "stop" && count < 50 do
    count = count + 1
    $cmcontinueAPI = URI.encode("https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500&cmcontinue=#{@cmcontinue}")
    response = Net::HTTP.get_response(URI.parse($cmcontinueAPI))
    data = response.body
    hash = JSON.parse(data)
    hash2 = hash["query"]["categorymembers"]

    #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
    #the cmcontinue variable is set.  If not, it is set to stop on the next loop
    if hash.key?("query-continue")
      @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"]
    else
      @cmcontinue = "stop"
    end

    hash2.each do |hash2|
      show = WikipediaApiQuery.new
      show.wikipedia_page_id = hash2["pageid"]
      show.show_name = hash2["title"]
      show.save
    end
  end
end


#This task queries from the "2010s_British_television_series" category list.
task :category_query_2010s_British_television_series => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  @query = "2010s_British_television_series"
  #this is the version to query a list of wikipedia entries by category. Deliver JSON with 500 item limit.
  #Need to combine key (the cmcontinue code) from results to continuation to get full list.
  $wikicategoryAPI = "https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500"
  response = Net::HTTP.get_response(URI.parse($wikicategoryAPI))
  data = response.body
  hash = JSON.parse(data)
  hash2 = hash["query"]["categorymembers"] #these hash key are what wikipedia uses to set up category lists.

  #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
  #the cmcontinue variable is set.  If not, it is set to stop on the next loop
  if hash.key?("query-continue")
    @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"] #this has key is used by wikipedia to pass a code for continuation of queries more than 500 results long.
  else
    @cmcontinue = "stop"
  end

  hash2.each do |hash2|
    show = WikipediaApiQuery.new
    show.wikipedia_page_id = hash2["pageid"]
    show.show_name = hash2["title"]
    show.save
  end

  #set while loop to keep querying category continuation until cmcontinue = nil or 50 attempts (30000 entries)
  #put in count condition to limit number of loops in case query returns change and cmco
  count = 0
  while @cmcontinue != "stop" && count < 50 do
    count = count + 1
    $cmcontinueAPI = URI.encode("https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500&cmcontinue=#{@cmcontinue}")
    response = Net::HTTP.get_response(URI.parse($cmcontinueAPI))
    data = response.body
    hash = JSON.parse(data)
    hash2 = hash["query"]["categorymembers"]

    #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
    #the cmcontinue variable is set.  If not, it is set to stop on the next loop
    if hash.key?("query-continue")
      @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"]
    else
      @cmcontinue = "stop"
    end

    hash2.each do |hash2|
      show = WikipediaApiQuery.new
      show.wikipedia_page_id = hash2["pageid"]
      show.show_name = hash2["title"]
      show.save
    end
  end
end


#This task queries from the "2000s_British_television_series" category list.
task :category_query_2000s_British_television_series => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  @query = "2000s_British_television_series"
  #this is the version to query a list of wikipedia entries by category. Deliver JSON with 500 item limit.
  #Need to combine key (the cmcontinue code) from results to continuation to get full list.
  $wikicategoryAPI = "https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500"
  response = Net::HTTP.get_response(URI.parse($wikicategoryAPI))
  data = response.body
  hash = JSON.parse(data)
  hash2 = hash["query"]["categorymembers"] #these hash key are what wikipedia uses to set up category lists.

  #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
  #the cmcontinue variable is set.  If not, it is set to stop on the next loop
  if hash.key?("query-continue")
    @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"] #this has key is used by wikipedia to pass a code for continuation of queries more than 500 results long.
  else
    @cmcontinue = "stop"
  end

  hash2.each do |hash2|
    show = WikipediaApiQuery.new
    show.wikipedia_page_id = hash2["pageid"]
    show.show_name = hash2["title"]
    show.save
  end

  #set while loop to keep querying category continuation until cmcontinue = nil or 50 attempts (30000 entries)
  #put in count condition to limit number of loops in case query returns change and cmco
  count = 0
  while @cmcontinue != "stop" && count < 50 do
    count = count + 1
    $cmcontinueAPI = URI.encode("https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500&cmcontinue=#{@cmcontinue}")
    response = Net::HTTP.get_response(URI.parse($cmcontinueAPI))
    data = response.body
    hash = JSON.parse(data)
    hash2 = hash["query"]["categorymembers"]

    #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
    #the cmcontinue variable is set.  If not, it is set to stop on the next loop
    if hash.key?("query-continue")
      @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"]
    else
      @cmcontinue = "stop"
    end

    hash2.each do |hash2|
      show = WikipediaApiQuery.new
      show.wikipedia_page_id = hash2["pageid"]
      show.show_name = hash2["title"]
      show.save
    end
  end
end


#This task queries from the "1990s_American_television_series" category list.
task :category_query_1990s_American_television_series => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  @query = "1990s_American_television_series"
  #this is the version to query a list of wikipedia entries by category. Deliver JSON with 500 item limit.
  #Need to combine key (the cmcontinue code) from results to continuation to get full list.
  $wikicategoryAPI = "https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500"
  response = Net::HTTP.get_response(URI.parse($wikicategoryAPI))
  data = response.body
  hash = JSON.parse(data)
  hash2 = hash["query"]["categorymembers"] #these hash key are what wikipedia uses to set up category lists.

  #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
  #the cmcontinue variable is set.  If not, it is set to stop on the next loop
  if hash.key?("query-continue")
    @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"] #this has key is used by wikipedia to pass a code for continuation of queries more than 500 results long.
  else
    @cmcontinue = "stop"
  end

  hash2.each do |hash2|
    show = WikipediaApiQuery.new
    show.wikipedia_page_id = hash2["pageid"]
    show.show_name = hash2["title"]
    show.save
  end

  #set while loop to keep querying category continuation until cmcontinue = nil or 50 attempts (30000 entries)
  #put in count condition to limit number of loops in case query returns change and cmco
  count = 0
  while @cmcontinue != "stop" && count < 50 do
    count = count + 1
    $cmcontinueAPI = URI.encode("https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500&cmcontinue=#{@cmcontinue}")
    response = Net::HTTP.get_response(URI.parse($cmcontinueAPI))
    data = response.body
    hash = JSON.parse(data)
    hash2 = hash["query"]["categorymembers"]

    #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
    #the cmcontinue variable is set.  If not, it is set to stop on the next loop
    if hash.key?("query-continue")
      @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"]
    else
      @cmcontinue = "stop"
    end

    hash2.each do |hash2|
      show = WikipediaApiQuery.new
      show.wikipedia_page_id = hash2["pageid"]
      show.show_name = hash2["title"]
      show.save
    end
  end
end


#This task queries from the "1980s_American_television_series" category list.
task :category_query_1980s_American_television_series => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  @query = "1980s_American_television_series"
  #this is the version to query a list of wikipedia entries by category. Deliver JSON with 500 item limit.
  #Need to combine key (the cmcontinue code) from results to continuation to get full list.
  $wikicategoryAPI = "https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500"
  response = Net::HTTP.get_response(URI.parse($wikicategoryAPI))
  data = response.body
  hash = JSON.parse(data)
  hash2 = hash["query"]["categorymembers"] #these hash key are what wikipedia uses to set up category lists.

  #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
  #the cmcontinue variable is set.  If not, it is set to stop on the next loop
  if hash.key?("query-continue")
    @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"] #this has key is used by wikipedia to pass a code for continuation of queries more than 500 results long.
  else
    @cmcontinue = "stop"
  end

  hash2.each do |hash2|
    show = WikipediaApiQuery.new
    show.wikipedia_page_id = hash2["pageid"]
    show.show_name = hash2["title"]
    show.save
  end

  #set while loop to keep querying category continuation until cmcontinue = nil or 50 attempts (30000 entries)
  #put in count condition to limit number of loops in case query returns change and cmco
  count = 0
  while @cmcontinue != "stop" && count < 50 do
    count = count + 1
    $cmcontinueAPI = URI.encode("https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&format=json&cmtitle=Category:#{@query}&cmlimit=500&cmcontinue=#{@cmcontinue}")
    response = Net::HTTP.get_response(URI.parse($cmcontinueAPI))
    data = response.body
    hash = JSON.parse(data)
    hash2 = hash["query"]["categorymembers"]

    #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue"), if yes,
    #the cmcontinue variable is set.  If not, it is set to stop on the next loop
    if hash.key?("query-continue")
      @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"]
    else
      @cmcontinue = "stop"
    end

    hash2.each do |hash2|
      show = WikipediaApiQuery.new
      show.wikipedia_page_id = hash2["pageid"]
      show.show_name = hash2["title"]
      show.save
    end
  end
end