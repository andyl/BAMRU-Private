ENV["RACK_ENV"] ||= "test"
require File.expand_path("../../app", __FILE__)
require "rspec"
require "capybara"
require "capybara/dsl"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Capybara
  config.before(:each) { Action.delete_all_with_validation }
end
