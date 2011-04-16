require 'spec_helper'

describe User do

 describe "Object Attributes" do
   before(:each) { @obj = User.new }
   specify { @obj.should respond_to(:first_name) }  
   specify { @obj.should respond_to(:last_name)  }  
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
   it { should     have_valid(:first_name).when("Joe") } 
   it { should_not have_valid(:first_name).when("")    } 
   it { should     have_valid(:last_name).when("Sue")  } 
   it { should_not have_valid(:last_name).when("")     } 
 end

end
