source "http://rubygems.org"

platforms :jruby do
  gem "jruby-poi", '0.8.2'
end

platforms :ruby do

  #gem "rails",         "3.2.0.rc1"
  gem "rails",          "3.1.3"

  gem "rake"
  gem "sqlite3"
  gem "faye",          "0.6.4"
  gem "pngqr"
  gem "em-http-request"
  gem "thin"

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
  gem "ruby-gmail", :require => "gmail"
  gem "mime"
  gem "bcrypt-ruby", "~> 3.0.0"
  gem "mail_view", :git => "git://github.com/andyl/mail_view.git"

  # Asset template engines
  gem "json"
  gem "sass"
  gem "coffee-script"
  gem "uglifier"
  gem "therubyracer", :require => "v8"
  gem "whenever",     :require => false

  group :development, :test do
    gem "jasminerice"
    gem "annotate", :git => 'git://github.com/jeremyolliver/annotate_models.git', :branch => 'rake_compatibility'
    gem "csv-mapper"
    gem "rb-inotify"
    gem "guard"
    gem "guard-coffeescript"
    #gem "livereload"
    #gem "guard-livereload"
    gem "faker"
    gem "rcov"
    gem "ruby-debug19", :require => "ruby-debug" if ENV['SYSNAME'] == 'ekel'
    gem "rspec-rails"
    gem "shoulda-matchers"
    gem "selenium-webdriver", "~> 2.0"
    gem "capybara", "~> 1.1.1"
    gem "launchy"
    gem "spork", "~> 0.9.0.rc9"
    gem "database_cleaner"

    gem "hirb"
    gem "wirble"
    gem "interactive_editor"
    gem "awesome_print", :require => "ap"
    gem "drx"
    gem "letter_opener"
  end
end
