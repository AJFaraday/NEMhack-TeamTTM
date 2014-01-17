#
# Find and store relevant location data using geocoder gem
#
require 'geocoder'
require 'yaml'
#
# Contents of a geocode
#
=begin
{
  "address_components"=>[
    {"long_name"=>"Guildford", "short_name"=>"Guildford", "types"=>["locality", "political"]}, 
    {"long_name"=>"Surrey", "short_name"=>"Surrey", "types"=>["administrative_area_level_2", "political"]}, 
    {"long_name"=>"England", "short_name"=>"England", "types"=>["administrative_area_level_1", "political"]}, 
    {"long_name"=>"United Kingdom", "short_name"=>"GB", "types"=>["country", "political"]}, 
    {"long_name"=>"Guildford", "short_name"=>"Guildford", "types"=>["postal_town"]}
  ], 
  "formatted_address"=>"Guildford, Surrey, UK", 
  "geometry"=>{
    "bounds"=>{
      "northeast"=>{"lat"=>51.2711197, "lng"=>-0.5084325}, 
      "southwest"=>{"lat"=>51.211911, "lng"=>-0.6224141}
    }, 
    "location"=>{"lat"=>51.23622, "lng"=>-0.570409}, 
    "location_type"=>"APPROXIMATE", 
    "viewport"=>{
      "northeast"=>{
        "lat"=>51.2711197, 
        "lng"=>-0.5084325
      }, 
      "southwest"=>{
         "lat"=>51.211911, 
         "lng"=>-0.6224141
      }
    }
  }, 
  "types"=>["locality", "political"]
}
=end
config = YAML.load_file("#{File.dirname(__FILE__)}/../config.yml")

# search result, 
geo = Geocoder.search(config['location'])[0].data

# four lines in the square boundary
n = north  = geo['geometry']['viewport']['northeast']['lat']
s = south  = geo['geometry']['viewport']['southwest']['lat']
w = west   = geo['geometry']['viewport']['southwest']['lng']
e = east   = geo['geometry']['viewport']['northeast']['lng']


data = {
  :place => geo['formatted_address'],
  :boundaries => [w,s,e,n],
  :north => n,
  :south => s,
  :west => w,
  :east => e
}

File.open("#{File.dirname(__FILE__)}/../geography.yml", 'w') {|f| f.write data.to_yaml }

