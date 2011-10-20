require 'spec_helper'

describe DoHandoff do
  before(:all) do
    @valid_attrs = {:incoming_do_id => 2, :outgoing_do_id => 2}
  end

  describe "object attributes" do
    before(:each) { @obj = DoHandoff.new }
    specify { @obj.should respond_to(:incoming_do_id)       }
    specify { @obj.should respond_to(:created_by_id)        }
    specify { @obj.should respond_to(:status)               }
    specify { @obj.should respond_to(:finished_at)          }
  end

  describe "associations" do
    before(:each) { @obj = DoHandoff.new }
    specify { @obj.should respond_to(:incoming_do)          }
    specify { @obj.should respond_to(:created_by)           }
  end

  describe "instance methods" do
    before(:each) { @obj = DoHandoff.new }
    specify { @obj.should respond_to(:send_start_notice)      }
  end

  describe "status validation" do
    before(:each) { @obj = DoHandoff.new(@valid_attrs) }

    it "is valid upon creation" do
      @obj.should be_valid
    end
    it "is valid with status:finished" do
      @obj.status = "finished"
      @obj.should be_valid
    end
    it "is invalid with unrecognized status" do
      @obj.status = "whatever"
      @obj.should_not be_valid
    end
  end

  describe "object creation" do
    before(:each) { @obj = DoHandoff.create(@valid_attrs) }
    specify { @obj.status.should == "started"}
    it "has one object" do
      DoHandoff.all.length.should == 1
    end
    context "after creating a second object" do
      before(:each) { DoHandoff.create(@valid_attrs) }
      specify { DoHandoff.all.length.should           == 2  }
      specify { DoHandoff.started.all.length.should   == 1  }
      specify { DoHandoff.abandoned.all.length.should == 1  }
      specify { DoHandoff.finished.all.length.should  == 0  }
    end
  end

end
# == Schema Information
#
# Table name: do_handoffs
#
#  id                 :integer         not null, primary key
#  outgoing_do_id     :integer
#  incoming_do_id     :integer
#  created_by_id      :integer
#  status             :string(255)
#  started_at         :datetime
#  finished_at        :datetime
#  next_reminder_time :datetime
#  num_reminders      :integer
#  created_at         :datetime
#  updated_at         :datetime
#

