require "instagram"
require 'yaml'


my_config = YAML.load_file("config.yml")

Instagram.configure do |config|
  config.client_id =     my_config['instagram']['client_id']
  config.client_secret = my_config['instagram']['client_secret']
end

# find latitude and longitude at:
# http://www.latlong.net/convert-address-to-lat-long.html

# Guildford 51.236220, -0.570409
lat = 51.236220
long = -0.570409

i = 0

loop do 

  i += 1  

  puts "iteration #{i}"

  puts "Looking for images from lat: #{lat} long: #{long}"

  # Get a list of media close to a given latitude and longitude.

  images = Instagram.media_search(lat,long)

  urls = images.collect{|x|x[:images][:standard_resolution][:url]}

  image_list = `ls #{File.dirname(__FILE__)}/../images`

  urls.each do |image_url|
    if image_list.include?(image_url.split('/')[-1])
      puts "#{image_url} is already downloaded."
    else
      `cd #{File.dirname(__FILE__)}/../images && wget #{image_url}`
    end
  end

  # Take a break
   
  sleep 5

  # look for locations (points of interest) and pull media linked to these locations
  locations = Instagram.location_search(lat, long)

  locations.each_with_index do |location,idx|

    puts "location #{idx + 1} of #{locations.count}"
    puts "Looking for images from #{location[:name]}"

    images = Instagram.location_recent_media(location[:id])

    urls = images.collect{|x|x[:images][:standard_resolution][:url]}

    image_list = `ls #{File.dirname(__FILE__)}/../images`

    urls.each do |image_url|
      if image_list.include?(image_url.split('/')[-1])
        puts "#{image_url} is already downloaded."
      else
        `cd #{File.dirname(__FILE__)}/../images && wget #{image_url}`
      end
    end

  end

  # take a break
 
  sleep 5

end
