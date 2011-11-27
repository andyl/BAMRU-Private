source 'http://rubygems.org'

platforms :jruby do
  gem 'jruby-poi', '0.8.2'
end

platforms :ruby do

  gem "linecache", "0.43"
  gem "sqlite3"
  gem "sqlite3-ruby", :require => "sqlite3"
  gem "faye",          "0.7.0"
  gem "pngqr"
  gem "em-http-request"
  gem "thin"

  gem "rails",         "3.1.0"
  gem "capistrano"
  gem "factory_girl"
  gem "fastercsv"
  gem "nokogiri"
  gem "simple_form"
  gem "rabl"
  gem "sprite-factory"
  gem "rmagick"

  gem "draper"

  gem "rack-offline"

  gem "jquery-rails"
  gem "paperclip"
  gem "parslet"
  gem "aalf",         :git => "http://github.com/andyl/aalf.git"
  gem "dynamic_form"
  gem "cancan"
  gem "mail"
  gem "prawn"
  gem "foreman"
  gem "oauth"
  gem "ruby-gmail", :require => 'gmail'
  gem 'mime'
  gem 'mail_view', :git => "git://github.com/andyl/mail_view.git"

  # Asset template engines
  gem 'json'
  gem 'sass'
  gem 'coffee-script'
  gem 'uglifier'
  gem 'therubyracer', :require => 'v8'
  gem 'whenever', :require => false

  group :development, :test do
    gem "jasminerice"
    gem 'annotate', :git => 'git://github.com/jeremyolliver/annotate_models.git', :branch => 'rake_compatibility'
    gem 'csv-mapper'
    gem 'rb-inotify'
    gem 'guard'
    gem 'guard-coffeescript'
    gem 'livereload'
    gem 'guard-livereload'
    gem "faker"
    gem "rcov"
    gem "ruby-debug"
    gem "rspec-core",  "2.7.1"
    gem "rspec-rails", "2.7.0"
    gem "shoulda-matchers"
    gem "selenium-webdriver", "~> 2.0"
    gem "capybara", "~> 1.1.1"
    #gem "capybara-webkit", "~> 0.7.2" # see notes in spec_opts.rb
    gem "launchy"
    gem 'spork', '~> 0.9.0.rc9'
    gem 'database_cleaner'

    gem "hirb"
    gem "wirble"
    gem "interactive_editor"
    gem "awesome_print", :require => "ap"
    gem "drx"
    gem "letter_opener"
  end
end
