require 'spec_helper'
require 'lib/address_parser'

describe AddressParser do

  before(:each) { @obj = AddressParser.new }

  it "works" do
    @obj.should_not be_nil
  end

end