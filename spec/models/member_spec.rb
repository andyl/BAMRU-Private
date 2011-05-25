require 'spec_helper'

describe Member do

 describe "Object Attributes" do
   before(:each) { @obj = Member.new }
   specify { @obj.should respond_to(:first_name) }  
   specify { @obj.should respond_to(:last_name)  }  
   specify { @obj.should respond_to(:user_name)  }
 end

 describe "Associations" do
   before(:each) { @obj = Member.new }
   specify { @obj.should respond_to(:addresses)     } 
   specify { @obj.should respond_to(:phones)        } 
   specify { @obj.should respond_to(:emails)        } 
   specify { @obj.should respond_to(:roles)         } 
   specify { @obj.should respond_to(:photos)        } 
   specify { @obj.should respond_to(:pdo_quarters)  }
   specify { @obj.should respond_to(:messages)      } 
   specify { @obj.should respond_to(:distributions) } 
 end

 describe "Instance Methods" do
   before(:each) { @obj = Member.new }
 end

 describe "Validations" do
   context "self-contained" do
     it { should validate_presence_of(:user_name)          }
     it { should validate_presence_of(:first_name)         }
     it { should validate_presence_of(:last_name)          }
     it { should validate_format_of(:user_name).with("xxx.yyy") }
     it { should validate_presence_of(:user_name)          }
   end
   context "inter-object" do
     before(:each) do
       Member.create!(:user_name => "joe.louis", :password => "qwerasdf")
     end
     it { should validate_uniqueness_of(:user_name)        }
   end
 end

 describe "Object Creation" do
   it "works with a user_name attribute" do
     @obj = Member.create!(:user_name => "xxx.yyy")
     @obj.should be_valid
     @obj.first_name.should == "Xxx"
     @obj.last_name.should == "Yyy"
     @obj.user_name.should == "xxx.yyy"
   end
   it "works with user name attributes" do
     @obj = Member.create!(:first_name => "Xxx", :last_name => "Yyy")
     @obj.should be_valid
     @obj.first_name.should == "Xxx"
     @obj.last_name.should == "Yyy"
     @obj.user_name.should == "xxx.yyy"
   end
 end

  describe "#new_user_name_from_names" do
    before(:each) {@obj = Member.new(:first_name=>"Joe", :last_name=>"Smith")}
    it "should return the correct user_name" do
      @obj.new_username_from_names.should == "joe.smith"
    end
  end

  describe "#new_names_from_user_name" do
    before(:each) {@obj = Member.new(:user_name => "joe.smith")}
    it "should return the correct names" do
      @obj.new_names_from_username.should == ["Joe","Smith"]
    end
  end

  describe "#full_name" do
    it "returns the correct string" do
      @obj = Member.create!(:user_name => "joe.smith", :password => "asdfasdf")
      @obj.full_name.should == "Joe Smith"
    end
  end

  describe "#full_roles" do
    it "returns the correct string" do
      hash1 = {:user_name => "joe.smith", :password => "asdfasdf", :typ => "FM"}
      @obj = Member.create!(hash1)
      hash2 = {:typ => "Bd"}
      @obj.roles << Role.create!(hash2)
      @obj.full_roles.should be_a(String)
      @obj.full_roles.should == "Bd FM"
    end
  end

end
