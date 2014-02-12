require 'socket'

sock = UDPSocket.new
sock.connect('localhost',6000)
n = 0
x = 240
loop do 
  n += 1
  x += (rand(40)-20)
  sock.send "#{x % 480},#{n % 640}", 0
  sleep 0.1
end
