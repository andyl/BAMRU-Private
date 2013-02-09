ENV["RAILS_ENV"] = 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'launchy'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'database_cleaner'

# if this is commented out, Capybara will use the default selenium driver
# Sep 23 2011 webkit 0.6.0 isn't compatible with spork - generates errors
# Oct 26 2011 webkit 0.7.2 doesn't run
# Mar 20 2012 capybara-webkit 0.11.0 works on command line but fails within rubyMine
Capybara.javascript_driver = :webkit

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_examples = false
  config.before(:each) do
    if_is_request = example.metadata[:type] == :request
    DatabaseCleaner.strategy = if_is_request ? :truncation : :transaction
    DatabaseCleaner.start
  end
  config.after(:each) do
     DatabaseCleaner.clean
  end
end

def basic_auth(user)
  Member.find_or_create_by_user_name(user)
  ActionController::HttpAuthentication::Basic.encode_credentials user, "welcome"
end

def login(member)
  visit login_path
  fill_in "user_name", :with => member.user_name
  fill_in "password",  :with => 'welcome'
  click_button 'Log in'
end
