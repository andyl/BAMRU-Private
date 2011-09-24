require 'spec_helper'
require 'lib/carrier'

describe CarrierQueue do

  before(:each) { @obj = CarrierQueue.new }

  it "works" do
    @obj.should_not be_nil
  end

end

describe CarrierQueueCollection do

  before(:each) { @obj = CarrierQueueCollection.new }

  it "works" do
    @obj.should_not be_nil
  end
  
end
