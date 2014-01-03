require 'rubygems'
gem 'activerecord'

require 'sqlite3'
require 'active_record'

require './lib/classes.rb'

# Database Creation script for Hear The City
#
# Because this database is for working, real-time data none of this is to be considered long-term or permanent data. It will be regularly restarted.
# Because of this I am not bothering with standard migrations, just this creation script
#
# to start again:
# ruby scripts/drop_database.rb
#

# Use local sqlite
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'htcity.db'
)


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


