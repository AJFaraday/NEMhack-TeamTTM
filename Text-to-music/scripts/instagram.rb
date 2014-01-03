require './lib/init_db.rb'
require './lib/init_instagram.rb'

# find latitude and longitude at:
# http://www.latlong.net/convert-address-to-lat-long.html

# Guildford 51.236220, -0.570409

# Get a list of media close to a given latitude and longitude.

images = Instagram.media_search("51.236220","-0.570409")
InstaImage.create_from_array(images)


