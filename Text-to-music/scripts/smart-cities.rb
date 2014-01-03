#
# Andrew James Faraday - May 2012
#
# This script is to allow direct manual control of the text-to-music algorithm.
# After a simple check of speed (1 divided by numbers 1 to 10 = number of seconds between characters) the user is prompted to provide textual input which is then sonified.
# This is recommended as a first experience of the text-to-music system, so new users can see the correlation between their use of text and the resulting sound.
# press ctrl+c to exit the script
#

#
# Update, 11 Jun 2012
#
# The script, with a surprisingly simple set of changes, can now be fed a file, which it reads. This opens the rather mind-blowing possibility of running this line:
#
# ruby scripts/manual-input.rb scripts/manual-input.rb
#
# The above command will use this file to read and sonify this file including this comment about reading and sonifying this file.
#

require './lib/pd-connect'
require './lib/city_data'
include CityData

cities = ['Nantes', 'NEM Summit 2013']

# Set up a port into pd
pd = PureData.new



i = 0
loop do 
  city = get_city(cities[i % cities.length])
  puts "using city #{city['name']}"
  # Run City 
  pd.connection.puts("osc city #{city['name']};")
  pd.connection.puts("osc poi Description;")
  pd.connection.puts("osc image #{(i % cities.length) + 1};")
  pd.send_string(city['description'][0..140])
  # Cycle through POIS
  city['pois'].each_with_index do |poi, index|
    pd.connection.puts("osc poi #{poi['name']};")
    puts poi['name']
    if city['name'] == 'Nantes'
      pd.connection.puts("osc image #{index + 3};")
    else
      pd.connection.puts("osc image #{index + 6};")
    end 
    sleep 0.5
    pd.send_string(poi['description'][0..140])
  end
  i += 1
end
