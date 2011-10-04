require 'spec_helper'

describe MemberDecorator do

  def valid_atts
    {:first_name => "Hi", :last_name => "Bye"}
  end
  describe "Object Attributes" do
    before(:each) { @obj = MemberDecorator.new(Member.new(valid_atts)) }
    specify { @obj.should respond_to(:first_name)       }
    specify { @obj.should respond_to(:last_name)        }
    specify { @obj.should respond_to(:name_last_first)  }
    specify { @obj.name_last_first.should == "Bye, Hi"  }
  end

end



