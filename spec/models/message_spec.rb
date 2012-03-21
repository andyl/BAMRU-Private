require 'spec_helper'

describe Message do

  describe "associations" do
    before(:all) { @obj = Message.new }
    specify { @obj.should respond_to :author           }
    specify { @obj.should respond_to :rsvp             }
    specify { @obj.should respond_to :outbound_mails   }
    specify { @obj.should respond_to :recipients       }
  end

  describe "#generate" do
    before(:each) do
      @phon = FactoryGirl.create(:phone)
      @mem1 = FactoryGirl.create(:member_with_phone_and_email)
      @mem2 = FactoryGirl.create(:member_with_phone_and_email)
      @mesg = {"author_id" => "#{@mem1.id}", "ip_address" => "4.4.4.4", "text" => "zomg"}
      @dist = {"#{@mem1.id}_email" => "on", "#{@mem1.id}_phone" => "on", "#{@mem2.id}_phone" => "on"}
      @rsvp = ""
    end
    it "generates a valid message object" do
      msg = Message.generate(@mesg, @dist, @rsvp)
      msg.should be_a Message
      msg.should be_valid
      msg.rsvp.should be_false
      msg.author.phones.length.should == 3
      msg.author.emails.length.should == 3
      msg.distributions.length.should == 2
      msg.distributions.first.email.should == true
      msg.distributions.first.phone.should == true
      msg.distributions.first.outbound_mails.length.should == 6
    end
    it "generates a valid message object with rsvp" do
      rsvp = '{"prompt":"HI", "yes_prompt":"yes", "no_prompt":"NO"}'
      msg = Message.generate(@mesg, @dist, rsvp)
      msg.should be_a Message
      msg.should be_valid
      msg.rsvp.should be_true
    end
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

