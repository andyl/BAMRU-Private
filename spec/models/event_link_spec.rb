require 'spec_helper'

describe EventLink do

  #def valid_params
  #  {}
  #end

  describe "Object Attributes" do
    before(:each) { @obj = EventLink.new }
    specify { @obj.should respond_to(:event_id)             }
    specify { @obj.should respond_to(:data_link_id)         }
  end

  describe "Associations" do
    before(:each) { @obj = EventLink.new               }
    specify { @obj.should respond_to(:event)           }
    specify { @obj.should respond_to(:data_link)       }
  end

  describe "store methods" do

    describe "#keyval" do
      before(:each) { @obj = EventLink.new }
      it "handles string values" do
        @obj.keyval[:test] = "a"
        @obj.save
        @obj.keyval[:test].should == "a"
      end
      it "handles integer values" do
        @obj.keyval[:test] = 1
        @obj.save
        @obj.keyval[:test].should == 1
      end
      it "handles array values" do
        @obj.keyval[:test] = [1,2,3]
        @obj.save
        @obj.keyval[:test].should == [1,2,3]
      end
    end

    describe ".periods" do
      before(:each) { @obj = EventLink.new }
      it "works with method labels" do
        @obj.periods = [1]
        @obj.save
        @obj.periods.should include 1
      end
      it "supports delete" do
        @obj.periods = [1,2,3,4]
        @obj.periods.delete 3
        @obj.save
        @obj.periods.should == [1,2,4]
      end
      it "supports concatenation" do
        @obj.periods = [1,2,3,4]
        @obj.periods << 5
        @obj.save
        @obj.periods.should == [1,2,3,4,5]
      end
    end

  end

  #describe "Validations" do
  #end

  #describe "Instance Methods" do
  #end

end

# == Schema Information
#
# Table name: event_links
#
#  id           :integer          not null, primary key
#  event_id     :integer
#  data_link_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

