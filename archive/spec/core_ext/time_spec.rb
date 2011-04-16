require 'spec_helper'

describe Time, "core_ext" do

describe "#to_label" do
  it "returns a valid label" do
    Time.now.to_label.should_not be_nil
    Time.now.to_label.class.should == String
  end
end


end
