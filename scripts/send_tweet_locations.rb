require './lib/init_db.rb'
require 'socket'

sock = UDPSocket.new
sock.connect('localhost',6000)

@last_id = Tweet.first(:order => 'id desc').id
Tweet.all.each do |tweet|
  sock.send "tweet::::#{tweet.lat}::::#{tweet.long}::::#{tweet.content}", 0
  sleep 0.01
end


loop do 
  Tweet.all(:conditions => ["id > ?", @last_id]).each do |tweet|
    sock.send "tweet::::#{tweet.lat}::::#{tweet.long}::::#{tweet.content}", 0
    @last_id = tweet.id
  end
  sleep 1
end
