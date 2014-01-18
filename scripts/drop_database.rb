require './lib/init_db.rb'

ActiveRecord::Base.connection.execute('drop database hear_the_city;')

`rm #{File.dirname(__FILE__)}/../images/*`
`rm #{File.dirname(__FILE__)}/../public/notation/*`
