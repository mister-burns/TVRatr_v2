require 'rubygems'
require 'nokogiri'
require 'mechanize'
#require 'open-uri'

url = "http://www.imdb.com"

  name = "M*A*S*H"
  puts name
  agent = Mechanize.new
  agent.get(url)

  search_form = agent.page.form_with(:action => "/find")
  search_form.q = name
  search_form.s = "tt"
  search_form.submit

  agent.page.link_with(:text => /#{name}/i).click
  puts agent.page
  rating = agent.page.at(".titlePageSprite.star-box-giga-star").text.strip
  rating_count = agent.page.at("span[itemprop=ratingCount]").text.strip.gsub(/,/,"").to_i
  page_link = agent.page.uri.to_s

  puts rating
  puts rating_count
  puts page_link

  table = agent.page.search(".cast_list")
  @array = Array.new

  table.css('span[itemprop=name]').each do |row| #find nokogiri object in cast_last table where each row is actor name
    @array << row.text.strip  # iterate over rows and add each name to @array
  end

  puts @array

  agent.page.search('div.watch-bar a').each do |test|
    if test.css('h3').text.match(/watch now/i) && test.css('p').text.match(/amazon/i)
      puts "watch match"
      relative_link = test[:href]
      absolute_link = url + "#{relative_link}"
      agent.get(absolute_link)
      page_link = agent.page.uri.to_s
      puts page_link
    elsif test.css('h3').text.match(/Own it/i) && test.css('p').text.match(/amazon\.com/i)
      puts "own match"
      relative_link = test[:href]
      absolute_link = url + "#{relative_link}"
      agent.get(absolute_link)
      page_link = agent.page.uri.to_s
      puts page_link
    end
  end

