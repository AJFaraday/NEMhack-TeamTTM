require './lib/init_db.rb'
require './lib/init_instagram.rb'

geo = YAML.load_file("#{File.dirname(__FILE__)}/../geography.yml")

lat = geo[:lat]
long = geo[:lng]

i = 0

loop do 
  i += 1  
  puts "iteration #{i}"
  puts "Looking for images from lat: #{lat} long: #{long}"

  # Get a list of media close to a given latitude and longitude.
  images = Instagram.media_search(lat,long,{:distance => 5000})
  InstaImage.create_from_array(images)

  # Take a break
  sleep 5

end
