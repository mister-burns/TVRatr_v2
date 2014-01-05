require 'rubygems'
require 'json'
require 'net/http'

query = "Battlestar Galactica"

#this is the version to query a list of wikipedia entries by category. Deliver JSON with 500 item limit.
#Need to combine key (the cmcontinue code) from results to continuation to get full list.
$itunesAPI = "https://itunes.apple.com/search?term=#{URI.escape(query)}&entity=tvShow"
response = Net::HTTP.get_response(URI.parse($itunesAPI))
data = response.body
hash = JSON.parse(data)
puts hash["results"].first["artistLinkUrl"]
#hash["results"].each do |hash|
#  puts hash["artistName"]
#  puts hash["artistLinkUrl"]
#end
