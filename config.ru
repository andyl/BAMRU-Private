ENV['GEM_PATH'] = "/home/aleak/.gems"

require 'rubygems'
Gem.clear_paths
require 'sinatra'

require 'app'

run BamruApp
