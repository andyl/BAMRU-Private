require 'spec_helper'

describe PageGenSvc do

  describe "Object Attributes" do
    before(:all) { @obj = PageGenSvc.new }
    specify { @obj.should respond_to(:message) }
    specify { @obj.should respond_to(:members) }
    specify { @obj.should respond_to(:params)  }
  end

  describe "Instance Methods" do
    before(:all) { @obj = PageGenSvc.new }
    specify { @obj.should respond_to(:selected_members) }
    specify { @obj.should respond_to(:default_rsvp) }
    specify { @obj.should respond_to(:default_message)  }
  end

  describe "#default_message" do
    before(:each) { @obj = PageGenSvc.new }
    it "works with no format" do
      @obj.default_message.should == ""
    end
    it "works with (all|invite|leave|return)" do
      %w(all invite leave return).each do |format|
        @obj.format = format
        @obj.default_message.length.should > 2
      end
    end
  end

  describe "#should_check" do

    before(:each) do
      @mem = double()
      @mem.stub(:id) { 22 }
      @obj = PageGenSvc.new
      @obj.period = 44
    end

    context "when the target member is a selected_member" do
      it "returns false" do
        @obj.selected_members = [22]
        @obj.should_check?(@mem).should be_true
      end
    end

    context "when the target member is not a selected member" do
      it "returns true" do
        @obj.selected_members = []
        @obj.should_check?(@mem).should_not be_true
      end
    end

  end

end
