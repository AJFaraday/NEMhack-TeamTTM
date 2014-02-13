require './lib/init_db.rb'

loop do
  message = TTMMessage.oldest_unplayed
  message.play if message
  sleep 0.5
end