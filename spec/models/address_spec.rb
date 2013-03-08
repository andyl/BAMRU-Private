require 'spec_helper'

describe Address do

  describe "Object Attributes" do
    before(:each) { @obj = Address.new }
    specify { @obj.should respond_to(:address1)     }
    specify { @obj.should respond_to(:address2)     }
    specify { @obj.should respond_to(:city)         }
    specify { @obj.should respond_to(:state)        }
    specify { @obj.should respond_to(:zip)          }
    specify { @obj.should respond_to(:typ)          }
    specify { @obj.should respond_to(:position)     }
    specify { @obj.should respond_to(:full_address) }
  end

  describe "Associations" do
    before(:each) { @obj = Address.new }
    specify { @obj.should respond_to(:member)       }
  end

  describe "Instance Methods" do
    before(:each) { @obj = Address.new }
    specify { @obj.should respond_to(:non_standard_typ?) }
  end

  describe "Validations" do
    context "basic" do
      it { should validate_presence_of(:address1)      }
      it { should validate_presence_of(:city)          }
      it { should validate_presence_of(:state)         }
      it { should validate_presence_of(:zip)           }
    end
  end

  describe "Object Creation" do
    before(:each) do
      @valid_attributes = {
              :address1 => "xxx",
              :city     => "yyy",
              :state    => "zzz",
              :zip      => "44444"
      }
    end
    it "works with valid attribute" do
      @obj = Address.create!(@valid_attributes)
      @obj.should be_valid
    end
  end

  describe "Object Creation using #full_address=" do
    context "with valid input" do
      before(:each) { @address = "222 Bell Lane\nArcata CA 94234" }
      it "generates a valid object" do
        @obj = Address.new(:full_address => @address)
        @obj.should be_valid
        @obj.address1.should == "222 Bell Lane"
        @obj.city.should == "Arcata"
        @obj.state.should == "CA"
        @obj.zip.should == "94234"
      end
    end
    context "with missing zip" do
      before(:each) { @address = "222 Bell Lane\nArcata CA" }
      it "generates an invalid object" do
        @obj = Address.new(:full_address => @address)
        @obj.should_not be_valid
        @obj.errors.messages.length.should == 2
      end
    end
  end
  context "with missing state" do
    before(:each) { @address = "222 Bell Lane\nArcata 94323" }
    it "generates an invalid object" do
      @obj = Address.new(:full_address => @address)
      @obj.should_not be_valid
      @obj.errors.messages.length.should == 6
    end
  end
  context "with missing state and zip" do
    before(:each) { @address = "222 Bell Lane\nArcata" }
    it "generates an invalid object" do
      @obj = Address.new(:full_address => @address)
      @obj.should_not be_valid
      @obj.errors.messages.length.should == 6
    end
  end

  describe "Object updating using #full_address=" do
    context "with valid input" do
      before(:each) do
        @address = "222 Bell Lane\nArcata CA 94234"
        @obj = Address.create(:full_address => @address)
      end
      it "generates a valid object" do
        @obj.should be_valid
      end
      it "updates with valid input" do
        @address2 = "333 Bell Lane\nArcata CA 44444"
        @obj.update_attributes(:full_address => @address2)
        @obj.should be_valid
        @obj.zip.should == "44444"
      end
    end
    context "with invalid input" do
      before(:each) do
        @address = "222 Bell Lane\nArcata CA"
        @obj = Address.create(:full_address => @address)
      end
      it "generates an error with missing zip" do
        @address2 = "333 Bell Lane\nArcata CA"
        @obj.update_attributes(:full_address => @address2)
        @obj.should_not be_valid
      end
      it "generates an error with missing state" do
        @address2 = "333 Bell Lane\nArcata 44444"
        @obj.update_attributes(:full_address => @address2)
        @obj.should_not be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  typ        :string(255)
#  address1   :string(255)      default("")
#  address2   :string(255)      default("")
#  city       :string(255)      default("")
#  state      :string(255)      default("")
#  zip        :string(255)      default("")
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

