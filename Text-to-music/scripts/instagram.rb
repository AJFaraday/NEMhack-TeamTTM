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

# Get a list of media close to a given latitude and longitude.

images = Instagram.media_search("51.236220","-0.570409")

image_list = `ls #{File.dirname(__FILE__)}/../images`

images.each do |image|
  image_url = image[:images][:standard_resolution][:url]
  if image_list.include?(image_url.split('/')[-1])
    puts "#{image_url} is already downloaded."
  else
    `cd #{File.dirname(__FILE__)}/../images && wget #{image_url}`
  end
end 
