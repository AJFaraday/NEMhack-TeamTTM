module CityData

  require 'net/http'
  require 'uri'
  require 'json'

  def get_city(name='Nantes')
    uri = URI.parse("http://mashweb.fokus.fraunhofer.de:3008/api/cities?name=#{name}".gsub(/ /, '%20'))
    response = Net::HTTP.get(uri)
    city = JSON.parse(response)['items'][0]
    city['pois'] = get_pois(city['_id'])
    city 
  end

  def get_pois(city='5264f44019d4cf212c005559')
    uri = URI.parse("http://mashweb.fokus.fraunhofer.de:3008/api/pois?city=#{city}")
    response = Net::HTTP.get(uri)
    poi_data = JSON.parse(response)['items']
    # There are no comments on Nantes POIs, I must ask for some
    #poi_data.each do |poi|
    #  # get POI comments
    #  poi['comments'] = get_comments(poi['_id'])
    #end
  end

  def get_comments(poi="4f4f4c27d4374e800100001d")
    uri = URI.parse("http://mashweb.fokus.fraunhofer.de:3008/api/comments?poi=#{poi}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)['items'].collect{|comment| "#{comment['title']}: #{comment['body']}" unless comment['body'].strip.empty? }
  end

  #
  # This WON'T WORK! - I don't know if the API call exists
  #

  def post_comment(comment, poi="4f4f4c27d4374e800100001d")
    uri = URI.parse("http://mashweb.fokus.fraunhofer.de:3008/api/comment")
    response = Net::HTTP.post_form(uri, {
     :title => 'Autocomment',
     :body => comment
    })
  end
  
end
