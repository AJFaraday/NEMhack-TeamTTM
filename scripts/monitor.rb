# this script is to watch message busses and print out the result.

require './lib/init_db.rb'
loop do 
  MessageBus.all(:order => 'label asc').each do |bus|
    puts bus.to_s
  end
  sleep 0.5
end
