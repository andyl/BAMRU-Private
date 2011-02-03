require 'spec_helper'

describe "Factory" do

  context "User Factory" do
    specify { Factory(:user).should_not be_nil }
    specify { Factory(:user).should be_valid   }
    it "shows the right number of database records" do
      User.count.should == 0
      Factory(:user)
      User.count.should == 1
    end
  end

  context "Address Factory" do
    specify { Factory(:address).should_not be_nil }
    specify { Factory(:address).should be_valid   }
    it "shows the right number of database records" do
      Address.count.should == 0
      Factory(:address)
      Address.count.should == 1
    end
    it "generates an associated user" do
      f = Factory(:address)
      User.count.should == 1
      f.user.should_not be_nil
      f.user.should be_valid
    end
    it "allows an address to be added to an existing user" do
      u = Factory :user
      a1 = Factory :address, :user => u
      a2 = Factory :address, :user => u
      a1.user.should == u
      a2.user.should == u
      u.addresses.count.should == 2
    end
  end

  context "Phone Factory" do
    specify { Factory(:phone).should_not be_nil }
    specify { Factory(:phone).should be_valid   }
    it "shows the right number of database records" do
      Phone.count.should == 0
      Factory(:phone)
      Phone.count.should == 1 
    end
    it "generates an associated user" do
      p = Factory(:phone)
      User.count.should == 1
      p.user.should_not be_nil
      p.user.should be_valid
    end
    it "allows a phone to be added to an existing user" do
      u = Factory :user
      a1 = Factory :phone, :user => u
      a2 = Factory :phone, :user => u
      a1.user.should == u
      a2.user.should == u
      u.phones.count.should == 2
    end
  end

  context "Email Factory" do
    specify { Factory(:email).should_not be_nil }
    specify { Factory(:email).should be_valid   }
    it "shows the right number of database records" do
      Email.count.should == 0
      Factory(:email)
      Email.count.should == 1
    end
    it "generates an associated user" do
      p = Factory(:phone)
      User.count.should == 1
      p.user.should_not be_nil
      p.user.should be_valid
    end
    it "allows a phone to be added to an existing user" do
      u = Factory :user
      a1 = Factory :email, :user => u
      a2 = Factory :email, :user => u
      a1.user.should == u
      a2.user.should == u
      u.emails.count.should == 2
    end
  end

end
