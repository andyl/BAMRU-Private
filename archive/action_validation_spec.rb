require 'spec_helper'

describe Action, "Validations" do

  describe ":kind validity checks" do
    context "when using valid :kind field" do
      it "should be valid" do
        Factory.build(:action).should be_valid
        Factory.build(:action, :kind => 'meeting').should be_valid
        Factory.build(:action, :kind => 'training').should be_valid
        Factory.build(:action, :kind => 'event').should be_valid
        Factory.build(:action, :kind => 'non-county').should be_valid
      end
    end
    context "when using invalid :kind field" do
      specify { Factory.build(:action, :kind => 'invalid').should_not be_valid }
    end
  end

  describe ":check_dates validity checks" do
    context "when using valid date fields" do
      valid_dates = {:start => "2007-01-01", :finish => "2009-02-02" }
      specify { Factory.build(:action, valid_dates).should be_valid }
    end
    context "when finish is earlier than start" do
      invalid_dates = {:start => "2007-01-01", :finish => "2006-02-02" }
      specify { Factory.build(:action, invalid_dates).should_not be_valid }
    end
    context "when finish is not specified" do
      valid_dates = {:start => "2007-01-01" }
      specify { Factory.build(:action, valid_dates).should be_valid }
    end
    context "when start and finish are the same" do
      it "should be valid" do
        valid_dates = {:start => "2007-01-01", :finish => "2007-01-01" }
        Factory.build(:action, valid_dates).should be_valid
      end
      it "should set finish to nil" do
        identical_dates = {:start => "2007-01-01", :finish => "2007-01-01" }
        x = Factory(:action, identical_dates)
        x.finish.should be_nil
      end
    end
  end

  describe "digest/signature validity checks" do
    it "should not allow creation of duplicate events" do
      event_hash = {:title => "xx", :start => "2007-01-01", :location => "yy"}
      Factory(:action, event_hash)
      Factory.build(:action, event_hash).should_not be_valid
    end
  end

end
