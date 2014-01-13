require 'rubygems'
gem 'activerecord'

require 'mysql2'
require 'active_record'

config = YAML.load_file("config.yml")['database']
config.delete('database')
puts config.inspect

ActiveRecord::Base.establish_connection(config)
ActiveRecord::Base.connection.execute('create database hear_the_city')

