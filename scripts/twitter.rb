#
# Andrew James Faraday - May 2012
#
# The twitter stream script is a way to automatically feed the text-to-music algorithm from the twitter streaming api.
# A search, either default (from config.yml) or manually (from the command line) will be returned in real-time as tweets are posted and then sonified or kept in a queue (deal with by the twitter streaming api) to be sonified in turn.
#

require 'rubygems'
require 'highline/import'
require 'tweetstream' 
require './Text-to-music/lib/twitter-auth'
require './lib/init_db'
 
# Load attributes from the config file
config = YAML.load_file("#{File.dirname(__FILE__)}/../Text-to-music/twitter.yml")

consumer_key, consumer_secret, oauth_token, oauth_token_secret = get_twitter_auth(config)

# Configure TweetStream
TweetStream.configure do |config|
  config.consumer_key       = consumer_key
  config.consumer_secret    = consumer_secret
  config.oauth_token        = oauth_token
  config.oauth_token_secret = oauth_token_secret
  config.auth_method        = :oauth
end


# Set up new TweetStream client
ts = TweetStream::Client.new

ts.on_error do |error|
  puts "ERROR: #{error}"
end

geo = YAML.load_file("#{File.dirname(__FILE__)}/../geography.yml")

# Code to be run on finding a tweet matching search term.
ts.locations(geo[:boundaries]) do |status|
  begin
    # Output user and source  to the console 
    puts "user: #{status.user.screen_name}"
    puts "source: #{status.source}"
    if status.place
      puts "country: #{status.place.country}"
      puts "place: #{status.place.name}"
    end
    if status.geo and status.geo[:coordinates]
      puts "lat: #{status.geo[:coordinates][0]}"
      puts "long: #{status.geo[:coordinates][1]}"
    end
    
    string = "[#{status.user.screen_name}] #{status.text}"
    puts string
    puts ''
    sleep 1
  rescue => er
    # display any errors that occur while keeping the stream open.
    puts er.message
    puts er.backtrace
  end
end
  

 
