require 'spec_helper'

SAMPLE_HASH = {"22_email" => "on",
               "22_phone" => "on",
               "19_phone" => "on",
               "12_email" => "on"}


describe Message do

  describe "associations" do
    before(:all) { @obj = Message.new }
    specify { @obj.should respond_to :author           }
    specify { @obj.should respond_to :rsvp             }
    specify { @obj.should respond_to :outbound_mails   }
    specify { @obj.should respond_to :recipients       }
  end

  describe "ancestry" do

    context "basic object creation" do
      before(:all) { @msg = Message.new }
      specify { @msg.should respond_to :parent   }
      specify { @msg.should respond_to :children }
    end

    context "object creation with RSVP" do
      before(:all) do

      end
    end

    context "inter-object interactions" do
      before(:each) do
        @m1 = Message.create!
        @m2 = Message.new(:parent=> @m1)
      end

      it "has a parent" do
        @m1.should respond_to :parent
        @m2.should respond_to :children
        @m2.parent.should == @m1
      end
    end
  end

  describe "linked RSVPs" do
    context "creating a repage" do
      before(:each) do
        @mp = Message.create!
        @mc = Message.create(:parent => @mp, :linked_parent_rsvp => true)
      end
    end
    context "when updating a child"
    context "when updating a parent"
    context "when the tree is three levels deep"
    context "when the tree is four levels deep"
    context "when deleting a parent"
  end

  describe "#distributions_params" do
    before(:each) do
      @res = Message.distributions_params(SAMPLE_HASH)
      x = 1
    end

    it "returns the right number of keys" do
      @res.length.should == 3
    end
    it "returns an array of hashes" do
      @res.class.should == Array
      @res.first.class.should == Hash
    end
  end
  
end

# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  author_id  :integer
#  ip_address :string(255)
#  text       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  format     :string(255)
#

