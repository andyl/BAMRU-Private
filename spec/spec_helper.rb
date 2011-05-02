ENV["RACK_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec-rails'
require 'time'
require 'valid_attribute'

RSpec.configure do |config|
  config.mock_with :rspec
  config.before(:each) { User.delete_all }
  config.before(:each) { Address.delete_all }
  config.before(:each) { Phone.delete_all }
  config.before(:each) { Email.delete_all }
end

