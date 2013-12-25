# This task combines all parse rake tasks and runs them together.
task :query_active_categories => [:category_query_english_language_television_programming,
                                  :category_query_serial_drama_television_series,
                                  :category_query_british_drama_television_series,
                                  :category_query_2010s_American_television_series,
                                  :category_query_2010s_British_television_series,
                                  :category_query_American_childrens_television_series,
                                  :category_query_British_childrens_television_programmes,
                                  :query_serial_drama_list_and_mark_show_as_serialized
] do
  puts "Everything has been queried!"
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
task :category_query_American_childrens_television_series => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  @query = "American_children's_television_series"
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
task :category_query_British_childrens_television_programmes => :environment do

  require 'rubygems'
  require 'json'
  require 'net/http'

  # note %27 put into name in place of apostrope...this is how the link works
  @query = "British_children's_television_programmes"
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


#This task queries from the "American_children's_television_series" category list.
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

#This task queries from the "Serial_drama_television_series" category list and then saves a boolean
#in the show model to indicate the show is serialized.
task :query_serial_drama_list_and_mark_show_as_serialized => :environment do

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
  hash2 = hash["query"]["categorymembers"] #these nested hash keys are how wikipedia delivers category lists.

  #this if statement checks if there is a cmcontinue hash key (which actually stars with "query-continue" key), if yes,
  #the cmcontinue variable is set.  If not, the while loop is set to stop on the next iteration
  if hash.key?("query-continue")
    @cmcontinue = hash["query-continue"]["categorymembers"]["cmcontinue"] #this has key is used by wikipedia to pass a code for continuation of queries more than 500 results long.
  else
    @cmcontinue = "stop"
  end

  hash2.each do |hash2|
    page_id = hash2["pageid"]
    show = Show.where(:wikipedia_page_id => page_id).first_or_create
    show.serialized = true
    show.save
  end

  #set while loop to keep querying category continuation until cmcontinue does not return a result or 50 attempts (30000 entries)
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
      page_id = hash2["pageid"]
      show = Show.where(:wikipedia_page_id => page_id).first_or_create
      show.serialized = true
      show.save
    end
  end
end
