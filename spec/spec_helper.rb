require 'spork'
require 'spork/ext/ruby-debug'
require 'database_cleaner'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'capybara/rails'

  # if this is commented out, Capybara will use the default selenium driver
  # Sep 23 2011 webkit 0.6.0 isn't compatible with spork - generates errors
  # Oct 26 2011 webkit 0.7.2 doesn't run
  #Capybara.javascript_driver = :webkit

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_examples = false
    config.before(:each) do
      if example.metadata[:type] == :request
        DatabaseCleaner.strategy = :truncation
      else
        DatabaseCleaner.strategy = :transaction
      end
      DatabaseCleaner.start
    end
    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
end

