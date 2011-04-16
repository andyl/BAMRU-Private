require 'rubygems'
require 'time'
require 'factory_girl'
require 'active_record'
require 'active_support/core_ext'

BASE_DIR  = File.dirname(File.expand_path(__FILE__)) + "/../"
DATA_DIR  = BASE_DIR + "/data"

database_file = case ENV['RACK_ENV']
  when "production" : "production.sqlite3"
  when "test"       : "test.sqlite3"
  else "database.sqlite3"
end

# initialize the database
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  BASE_DIR + "db/#{database_file}"
)

# load all lib
Dir[BASE_DIR + "lib/**/*.rb"].each {|f| load f}

# load factory definitions
require BASE_DIR + "db/factories"
