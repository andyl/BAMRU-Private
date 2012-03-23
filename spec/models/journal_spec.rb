require 'spec_helper'

describe Journal do

  describe "associations" do
    before(:all) { @obj = Journal.new }
    specify { @obj.should respond_to :member           }
    specify { @obj.should respond_to :distribution     }
  end

  describe ".add_entry" do
    it "works with IDs" do
      @obj = Journal.add_entry(1,1,"hello")
      @obj.should_not be_nil
      @obj.action.should == "hello"
      @obj.distribution_id.should == 1
      @obj.member_id.should == 1
    end
    it "works with objects" do
      obj1 = FactoryGirl.create(:distribution)
      obj2 = FactoryGirl.create(:member)
      @obj = Journal.add_entry(obj1,obj2,"second")
      @obj.should_not be_nil
      @obj.action.should == "second"
      @obj.distribution_id.should == obj1.id
      @obj.member_id.should == obj2.id
    end
  end

end

# == Schema Information
#
# Table name: journals
#
#  id              :integer         not null, primary key
#  member_id       :integer
#  distribution_id :integer
#  action          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

