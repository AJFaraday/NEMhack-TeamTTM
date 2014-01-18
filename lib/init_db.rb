require 'rubygems'
gem 'activerecord'

require 'mysql2'
require 'active_record'


require "#{File.dirname(__FILE__)}/geography.rb"

puts Geography.get_location

# require all files in the models directory
Dir["./lib/models/*.rb"].each {|file| require file }

# Database Creation script for Hear The City
#
# Because this database is for working, real-time data none of this is to be considered long-term or permanent data. It will be regularly restarted.
# Because of this I am not bothering with standard migrations, just this creation script
#
# to start again:
# ruby scripts/drop_database.rb
#

# Use local mysql

config = YAML.load_file("config.yml")
ActiveRecord::Base.establish_connection(config['database'])


# create missing tables 
unless InstaImage.table_exists?
  ActiveRecord::Schema.define do
    create_table :insta_images do |t|
      t.column :label, :string
      t.column :lat, :float
      t.column :long, :float
      t.column :url, :string
      t.column :filename, :string
    end 
  end
end

unless MessageBus.table_exists?
  ActiveRecord::Schema.define do
    create_table :message_buses do |t|
      t.column :label, :string
      t.column :script_path, :string 
      t.column :model_name, :string
    end
  end
 
  MessageBus.create!(
    :label => 'Instagram',
    :script_path => 'scripts/instagram.rb',
    :model_name => 'InstaImage'
  )
  MessageBus.create!(
    :label => 'Twitter',
    :script_path => 'scripts/twitter.rb',
    :model_name => 'Tweet'
  )
end

unless Message.table_exists?
  ActiveRecord::Schema.define do
    create_table :messages do |t|
      t.column :text, :string
      t.column :ip_address, :string
      t.column :message_bus_id, :integer
    end
  end
end

unless TTMMessage.table_exists?
  ActiveRecord::Schema.define do
    create_table :ttm_messages do |t|
      t.column :text, :string
      t.column :file_generated, :boolean
      t.column :played, :boolean
      t.column :score_shown, :boolean
      t.column :source_type, :string
      t.column :source_id, :integer      
    end
  end
end

unless Tweet.table_exists?
  ActiveRecord::Schema.define do
    create_table :tweets do |t|
      t.column :username, :string 
      t.column :content, :string
      t.column :lat, :float
      t.column :long, :float
    end
  end
end
