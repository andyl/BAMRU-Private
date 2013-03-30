require 'spec_helper'

describe Role do

  def valid_params
    {member_id: 1, typ: "TM"}
  end

  describe "Object Attributes" do
    before(:each) { @obj = Role.new }
    specify { @obj.should respond_to(:typ)                }
    specify { @obj.should respond_to(:member_id)          }
  end

  describe "Associations" do
    before(:each) { @obj = Role.new(valid_params)  }
    specify { @obj.should respond_to(:member)      }
  end

  describe ".assign_role" do
    it "creates a Role" do
      member = stub
      member.stub(:id).and_return(1)
      role = Role.assign_role("TM", member)
      role.should be_valid
      role.member_id.should == 1
      role.typ.should == "TM"
    end
  end

end

