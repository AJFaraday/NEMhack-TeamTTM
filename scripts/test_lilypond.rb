require './lib/init_db'

x = TTMMessage.create(:text => 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789') 

puts x.image_path 
