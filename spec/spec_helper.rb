ENV["RACK_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec'
require 'time'

RSpec.configure do |config|
  config.mock_with :rspec
  config.before(:each) { Action.delete_all_with_validation }
end

# ----- This is for testing the CsvLoader -----

  TEST_FILE_VALID = "/tmp/test_valid.csv"
  TEST_FILE_ERRORS = "/tmp/test_errors.csv"
  NUM_INPUT = 5
  HEADER = %q("kind","title","location","description","start","finish","leaders")

  def csv_record(direction = "none")
    kind  = %w(meeting non-county training event).to_a.sample
    kind  = "invalid" if direction == "invalid"
    title = "Test Record " + (1..999).to_a.sample.to_s
    title = %q(Malformed " Record) if direction == "malformed"
    year  = (2001 .. 2012).to_a.sample
    month = ("01" .. "12").to_a.sample
    day   = ("01" .. "30").to_a.sample
    start = "#{year}-#{month}-#{day}"
    %Q("#{kind}","#{title}","","","#{start}","","")
  end

  def generate_valid_test_data
    output = HEADER + "\n"
    NUM_INPUT.times { output << csv_record + "\n" }
    File.open(TEST_FILE_VALID, 'w') {|f| f.puts output }
  end

  NUM_INVALID = 1
  NUM_MALFORMED = 1
  def generate_test_data_with_errors
    output = HEADER + "\n"
    (NUM_INPUT-2).times { output << csv_record + "\n" }
    output << csv_record("invalid") + "\n"
    output << csv_record("malformed") + "\n"
    File.open(TEST_FILE_ERRORS, 'w') {|f| f.puts output }
  end
