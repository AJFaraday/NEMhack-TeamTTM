require 'rubygems'
require "instagram"
require 'yaml'

my_config = YAML.load_file("config.yml")

Instagram.configure do |config|
  config.client_id =     my_config['instagram']['client_id']
  config.client_secret = my_config['instagram']['client_secret']
end

