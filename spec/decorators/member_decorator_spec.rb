require 'spec_helper'

describe MemberDecorator do

  def valid_atts
    {
      :first_name => "Hi",
      :last_name =>  "Bye",
      :phones_attributes => [
              {:number => "432-342-3433", :typ => "Mobile"}
      ]
    }
  end

  def create_valid_members(count = 2)
    (1..count).map do |m|
      atts = valid_atts
      atts[:first_name] = "Helloooooooooooo"[0..-m]
      Member.new(atts)
    end
  end

  before(:each) do
    @obj = MemberDecorator.new(Member.new(valid_atts))
  end

  describe "Object Attributes" do
    specify { @obj.should respond_to(:first_name)       }
    specify { @obj.should respond_to(:last_name)        }
    specify { @obj.should respond_to(:mobile_json)      }
  end

  describe "#mobile_json" do
    before(:each) { @obj = MemberDecorator.new(Member.new(valid_atts)) }
    specify { @obj.mobile_json.should_not be_nil }
    specify { @obj.mobile_json.should be_a(String) }
  end

  describe "self.mobile_json" do
    before(:each) do
      collection = create_valid_members(3)
      @col = MemberDecorator.mobile_json(collection)
    end
    specify { @col.should be_a String }
    specify { JSON.parse(@col).should_not be_nil  }
    specify { JSON.parse(@col).should be_an Array }
    specify { JSON.parse(@col).length.should == 3 }
    specify { JSON.parse(@col).first.should be_a Hash }
  end

end



