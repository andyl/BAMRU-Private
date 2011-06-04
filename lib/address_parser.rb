#!/usr/bin/env ruby

# This script parses US mailing addresses.
#
# For development, execute this from the command line to run the test cases.
#
# For production, just require the file, then:
#     address_hash = AddressParser.new.parse(input_string)

require 'rubygems'
require 'parslet'

class AddressParser < Parslet::Parser

  # case insensitive string match - copied from the 'Parslet Tips' page...
  def stri(str)
    key_chars = str.split(//)
    key_chars.
      collect! { |char| match["#{char.upcase}#{char.downcase}"] }.
      reduce(:>>)
  end

  # matches two-letter abbreviations for US states
  def state_match
    states = %w(mn ak hi id mt wy ut nm tx ks 
                ok nb sd nd ia ar la ms ab wi
                tn ky in oh pn wv md va nc sc
                ga de nj ct ri ma vt nh ma il
                ca co az nv fl mi ny or wa mo)
    eval states.map {|x| "stri('#{x}')"}.join(' | ')
  end
  
  # Single character rules
  rule(:comma)      { str(',') >> space? }
  rule(:space)      { match('\s').repeat }
  rule(:space?)     { space.maybe }
  rule(:spacecom)   { comma.maybe >> space }
  rule(:state_term) { (comma | eof | str(' ')) >> space}
  rule(:newline)    { (str("\r") | str("\n")).repeat }
  rule(:digit)      { match('[0-9]') }
  rule(:adr_char)   { match('[A-z0-9 \#\.\-\,]') }
  rule(:eof)        { any.absent? }

  # For Testing
  rule(:state_match_test)  { state_match }

  # Things
  rule(:word)       { match('[A-z]').repeat }

  # Address Parts
  rule(:address1)   { (adr_char.repeat).as(:address1) }
  rule(:address2)   { newline >> (adr_char.repeat).as(:address2) }
  rule(:address)    { address1 >> address2 }
  rule(:state)      { state_match.as(:state) >> state_term }
  rule(:zip)        { digit.repeat(2,5).as(:zip) >> space? >> eof }
  rule(:city1)      { word.as(:city) >> spacecom }
  rule(:city2)      { (word >> space >> word).as(:city) >> spacecom }
  rule(:city3)      { (word >> space >> word >> space >> word).as(:city) >> spacecom }
  rule(:sz)         { state >> zip.maybe }
  rule(:csz)        { (city1 >> sz) | (city2 >> sz) | (city3 >> sz) }

  # Top-Level
  rule(:all)        { (address1 >> newline >> csz) | (address >> newline >> csz) }
  root :all
end

if $0 == __FILE__

  def test_runner(rule, string)

    begin 
      parser = AddressParser.new
      eval "p parser.#{rule}.parse('#{string}')"
    rescue Parslet::ParseFailed => e
      puts "FAIL> #{rule}".rjust(20, '-') + ' > ' + string.gsub("\n",'/').ljust(60, '-')
      puts e, parser.root.error_tree
    end
  end

  # Test cases...
  test_runner(  "state_match_test", "Co")
  test_runner(  "state_match_test", "Ca")
  test_runner(  "state_match_test", "NY")
  test_runner(  "state_match_test", "fl")
  test_runner(  "state_match_test", "wa")
  test_runner(   "comma", ",")
  test_runner(   "digit", "5")
  test_runner(   "comma", ",")
  test_runner(   "digit", "5")
  test_runner("address1", "1523 Broker Way")
  test_runner("address1", "1523 Broker-Way")
  test_runner("address1", "1523 Broker Way, #22")
  test_runner("address1", "1523 Broker Rd., Apt. #22")
  test_runner( "address", "1523 Broker Way")
  test_runner( "address", "1523 Broker Way\nApartment 22")
  test_runner( "address", "1523 El Camino Real\r\nApartment 22")
  test_runner(     "zip", "94022")
  test_runner(     "zip", "94022 ")
  test_runner(   "state", "CA")
  test_runner(   "state", "Ca")
  test_runner(   "state", "ca")
  test_runner(   "state", "CO")
  test_runner(   "city1", "Sunnyvale")
  test_runner(   "city1", "Sunnyvale ")
  test_runner(   "city2", "Mountain View")
  test_runner(     "csz", "Mountain CA 94022")
  test_runner(     "csz", "Mountain View CA 94022")
  test_runner(     "csz", "SF CA 94022")
  test_runner(     "csz", "mountain view ca 94022")
  test_runner(     "csz", "mountain view, ca 94022")
  test_runner(     "csz", "los altos hills CA")
  test_runner(     "csz", "los altos hills, CA")
  test_runner(     "csz", "los altos hills  CA")
  test_runner(     "csz", "SF CA")
  test_runner(     "csz", "SF, CA")
  test_runner(     "all", "1523 Broker Way\nMountain View CA 94022")
  test_runner(     "all", "1523 Broker Way\nApartment 22\nMV CA 94022")
  test_runner(     "all", "1523 broker way\nmountain view ca 94022")

end
