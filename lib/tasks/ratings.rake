task :get_imdb_ratings => :environment do
  require 'mechanize'

  show = Show.where(:wikipedia_page_id => 20715044).first
  name = show.show_name

  agent = Mechanize.new
  agent.get("http://www.imdb.com")
  form = agent.page.forms.first
  form.q = name
  form.submit
  agent.page.link_with(:text => name).click
  value = agent.page.at(".star-box-details").text
  puts value


end