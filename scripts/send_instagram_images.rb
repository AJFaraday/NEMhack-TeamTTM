require './lib/init_db.rb'
require 'socket'

sock = UDPSocket.new
sock.connect('localhost',6000)

@last_id = InstaImage.first(:order => 'id desc').id
InstaImage.all.each do |i|
  sock.send "instagram::::#{i.lat}::::#{i.long}::::#{i.url}", 0
  sleep 0.01
end


loop do 
  InstaImage.all(:conditions => ["id > ?", @last_id]).each do |i|
    sock.send "instagram::::#{i.lat}::::#{i.long}::::#{i.url}", 0
    @last_id = i.id
  end
  sleep 1
end
