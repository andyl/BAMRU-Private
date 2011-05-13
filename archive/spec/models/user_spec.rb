require 'spec_helper'

describe User do

 describe "Object Attributes" do
   before(:each) { @obj = User.new }
   specify { @obj.should respond_to(:first_name) }  
   specify { @obj.should respond_to(:last_name)  }  
   specify { @obj.should respond_to(:login)      }
 end

 describe "Associations" do
   before(:each) { @obj = User.new }
   specify { @obj.should respond_to(:addresses)     } 
   specify { @obj.should respond_to(:phones)        } 
   specify { @obj.should respond_to(:emails)        } 
   specify { @obj.should respond_to(:roles)         } 
   specify { @obj.should respond_to(:photos)        } 
   specify { @obj.should respond_to(:do_avails)     } 
   specify { @obj.should respond_to(:messages)      } 
   specify { @obj.should respond_to(:distributions) } 
 end

 describe "Validations" do
#   subject { User.new }
#   it { should     have_valid(:first_name).when("Joe")  }
#   it { should_not have_valid(:first_name).when("")     }
#   it { should     have_valid(:first_name).when("J x")  }
#   it { should     have_valid(:first_name).when("J.x")  }
#   it { should_not have_valid(:first_name).when("J_x")  }
#   it { should_not have_valid(:first_name).when("")     }
#   it { should     have_valid(:last_name).when("Smith") }
#   it { should_not have_valid(:last_name).when("")      }
#   it { should     have_valid(:login).when("joe.smith") }
#   it { should_not have_valid(:login).when("")          }

   it { should validate_presence_of(:login)      }
   it { should validate_presence_of(:first_name) }
   it { should validate_presence_of(:last_name)  }
   it { should validate_format_of(:login).with("xxx.yyy") }
   it { should validate_presence_of(:login) }
 end

 describe "Object Creation" do
   it "works with a login attribute" do
     @obj = User.create!(:login => "xxx.yyy")
     @obj.should be_valid
     @obj.first_name.should == "Xxx"
     @obj.last_name.should == "Yyy"
     @obj.login.should == "xxx.yyy"
   end
   it "works with user name attributes" do
     @obj = User.create!(:first_name => "Xxx", :last_name => "Yyy")
     @obj.should be_valid
     @obj.first_name.should == "Xxx"
     @obj.last_name.should == "Yyy"
     @obj.login.should == "xxx.yyy"
   end
 end

  describe "#new_login_from_names" do
    before(:each) {@obj = User.new(:first_name=>"Joe", :last_name=>"Smith")}
    it "should return the correct login" do
      @obj.new_login_from_names.should == "joe.smith"
    end
  end

  describe "#new_names_from_login" do
    before(:each) {@obj = User.new(:login => "joe.smith")}
    it "should return the correct names" do
      @obj.new_names_from_login.should == ["Joe","Smith"]
    end
  end

end
