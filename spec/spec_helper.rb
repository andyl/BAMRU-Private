ENV["RAILS_ENV"] = 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'launchy'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'database_cleaner'

# if this is commented out, Capybara will use the default selenium driver
Capybara.javascript_driver = :webkit

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_examples = false
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    is_request    = example.metadata[:type] == :request
    not_rack_test = Capybara.current_driver != :rack_test
    DatabaseCleaner.strategy = if is_request || not_rack_test
                                 :truncation
                               else
                                 :transaction
                               end
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

def create_member(username)
  mem = Member.find_or_create_by_user_name_and_typ(username, "FM")
  puts('*' * 60, "NO MEM") if mem.blank?
  mem
end

# use this in requests specs, on controllers that use 'authenticate_member_with_basic_auth'
# cred = basic_auth("joe_smith")
# get '/path', nil, {'HTTP_AUTHORIZATION' => cred}
def basic_auth(username, password="welcome")
  create_member(username)
  ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
end

# use this in requests specs, on controllers that use 'authenticate_member_with_basic_auth'
def http_login(username, password = "welcome")
  create_member(username)
  request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username,password)
end

# use this in requests specs, on controllers that use 'authenticate_member'
def request_login(username, password = "welcome")
  post sessions_path, :login => username, :password => password
end

# use this with feature specs
def login(username, password = "welcome")
  member = create_member(username)
  puts('*' * 60, "NO MEMBER") if member.blank?
  visit login_path
  fill_in "user_name", :with => username
  fill_in "password",  :with => password
  click_button 'Log in'
  member
end
