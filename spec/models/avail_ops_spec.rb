require 'spec_helper'

describe AvailOp do

  describe "object attributes" do
    before(:each) { @obj = AvailOp.new }
    specify { @obj.should respond_to(:start)    }
    specify { @obj.should respond_to(:end)      }
    specify { @obj.should respond_to(:comment)  }
  end

  describe "associations" do
    before(:each) { @obj = AvailOp.new }
    specify { @obj.should respond_to(:member)          }
  end

  describe "instance methods" do
    before(:each) { @obj = AvailOp.new }
    specify { @obj.should respond_to(:cleanup_dates)   }
  end

  describe "validations" do
    before(:each) { @obj = AvailOp.new }
    specify { @obj.should validate_presence_of(:start)          }
    specify { @obj.should validate_presence_of(:end)            }
  end

  describe "object creation" do
    context "using date input" do
      before(:each) do
        @valid_input  = {:start => 1.week.from_now, :end => 2.weeks.from_now }
      end
      it "works with valid input" do
        @obj = AvailOp.create!(@valid_input)
        @obj.should be_valid
      end
    end
    context "using text date input" do
      before(:each) do
        @string_input = {:start_txt => '2011-02-13', :end_txt => '2011-03-22' }
      end
      it "works with string input" do
        @obj = AvailOp.create!(@string_input)
        @obj.should be_valid
        @obj.start.should_not be_blank
        @obj.start.should be_a(Time)
        @obj.end.should_not be_blank
        @obj.end.should be_a(Time)
      end
    end
  end

  describe "object updating" do
    context "using string update criteria" do
      before(:each) do
        @obj = AvailOp.create(:start => 2.days.from_now, :end => 3.days.from_now)
      end
      it "updates the object" do
        date_str = "2011-01-01"
        @obj.update_attributes(:start_txt => date_str)
        @obj.should be_valid
        @obj.start_txt.should == date_str
      end
      it "updates the object using a string hash key" do
        date_str = "2011-01-01"
        @obj.update_attributes('start_txt' => date_str)
        @obj.should be_valid
        @obj.start_txt.should == date_str
      end
    end
  end
end