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
  images = Instagram.media_search(lat,long)
  InstaImage.create_from_array(images)

  # Take a break
  sleep 5

  # look for locations (points of interest) and pull media linked to these locations
  locations = Instagram.location_search(lat, long)

  locations.each_with_index do |location,idx|
    puts "location #{idx + 1} of #{locations.count}"
    puts "Looking for images from #{location[:name]}"

    images = Instagram.location_recent_media(location[:id])
    InstaImage.create_from_array(images)
  end

  # take a break
  sleep 5
end
