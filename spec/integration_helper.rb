ENV["RACK_ENV"] ||= "test"
require File.expand_path("../../app", __FILE__)
require "rspec"
require "capybara"
require "capybara/dsl"

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Capybara
  config.before(:each) { Action.delete_all_with_validation }
end

