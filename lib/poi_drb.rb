#!/usr/bin/env ruby

# About PoiDrb...
#
# Apache POI allows server-side creation and
# modification of excel spreadsheets.
#
# The jruby-poi gem is an interface to Apache POI.
#
# This script (PoiDrb) provides a DRb service for jruby-poi.
# Using PoiDrb, MRI clients can use jruby-poi.
#
# PoiDrb is meant to be used in situations where 
# a script needs to modify and save an Excel template.
#
# Here's a sample PoiDrb client:
#
# require 'drb'
# poi = DRbObject.new(nil, 'druby://localhost:9000')
# poi.read 'input_template.xls'
# poi.set  'Sheet1!A1', "new value for this cell"
# poi.set_style 'Sheet1!A1', :header
# poi.write 'output_file.xls'

msg = "ABORTING: MUST RUN WITH JRUBY\n(rvm use jruby)"
abort msg unless RUBY_PLATFORM == "java"

require 'rubygems'
require 'poi'

class PoiDrb

  BLANK_STYLE = {
    :border_left           => :border_none, 
    :border_right          => :border_none, 
    :border_top            => :border_none, 
    :border_bottom         => :border_none, 
    :fill_foreground_color => :white
  }

  HEADER_STYLE = {
    :right_border_color    => :black,
    :left_border_color     => :black, 
    :top_border_color      => :black, 
    :bottom_border_color   => :black, 
    :border_left           => :border_thin, 
    :border_right          => :border_thin, 
    :border_top            => :border_thin, 
    :border_bottom         => :border_thin, 
    :boldweight            => :boldweight_bold,
    :fill_pattern          => :solid_foreground,
    :fill_foreground_color => :grey_25_percent
  }

  def initialize(input_file = "")
    read(input_file) unless input_file.empty?
  end

  def read(input_file)
    @input_file = input_file
    @poi = POI::Workbook.open(input_file)
    @style_hash = {
      :blank => @poi.create_style(BLANK_STYLE),
      :header => @poi.create_style(HEADER_STYLE)
    }
  end

  def get(coord)
    @poi[coord]
  end

  def set(coord, value)
    cell(coord).value = value
  end

  def set_style(coord, style)
    cell(coord).style = @style_hash[style]
  end

  def set_formula(coord, formula)
    cell(coord).formula = formula
  end

  def write(output_file)
    @poi.save_as(output_file)
  end

  def render
    write     '/tmp/xx.xls'
    File.read '/tmp/xx.xls'
  end

  private

  def cell(coord)
    name, xy = coord.split('!')
    sheet = @poi.worksheets[name]
    x = ('A'..'Z').to_a.join.index xy[0..0]
    y = xy[1..-1].to_i - 1
    sheet[y][x]
  end

end

# if called as a script, start the DRb server
if File.basename($0) == File.basename(__FILE__)
  require 'drb'
  DRb.start_service('druby://localhost:9000', PoiDrb.new)
  puts "Starting PoiDrb server on port 9000 @ #{Time.now}"
  puts "Ctrl-C to exit..."
  DRb.thread.join
end
