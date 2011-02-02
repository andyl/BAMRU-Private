require 'spec_helper'

describe "Factory" do

  context "Using the Action Factory" do
    it "should create action objects w/o crashing" do
      Factory(:action).should_not be_nil
    end
    it "should create valid action objects" do
      Factory(:action).should be_valid
    end
  end

  context "Database Cleaning" do
    it "should have no event records when starting" do
      Action.count.should == 0
    end

    it "should be able to create a single record" do
      Factory(:action)
      Action.count.should == 1
    end

    it "should have no records when running the next spec" do
      Action.count.should == 0
    end
  end

end
