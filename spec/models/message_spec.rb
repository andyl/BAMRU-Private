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
      @mem1 = FactoryGirl.create(:member_with_phone_and_email)
      @mem2 = FactoryGirl.create(:member_with_phone_and_email)
      @mesg = {"author_id" => "#{@mem1.id}", "ip_address" => "4.4.4.4", "text" => "zomg"}
      @dist = {"#{@mem1.id}_email" => "on", "#{@mem1.id}_phone" => "on", "#{@mem2.id}_phone" => "on"}
      @rsvp = ""
    end
    it "generates a valid message object", slow: true do
      msg = Message.generate(@mesg, @dist, @rsvp)
      msg.should be_a Message
      msg.should be_valid
      msg.rsvp.should be_false
      author = msg.author
      author.phones.length.should == 3
      author.emails.length.should == 3
      dists = msg.distributions.all
      dists.length.should == 2
      dists.first.email.should == true
      dists.first.phone.should == true
      dists.first.outbound_mails.length.should == 6
    end
    it "generates a valid message object with rsvp", slow: true do
      rsvp = '{"prompt":"HI", "yes_prompt":"yes", "no_prompt":"NO"}'
      msg = Message.generate(@mesg, @dist, rsvp)
      msg.should be_a Message
      msg.should be_valid
      msg.rsvp.should be_true
    end
  end

  describe "ancestry" do

    context "basic object manipulation" do
      before(:each) do
        @msg1 = Message.create
        @msg2 = Message.create(:parent => @msg1)       # using the object
        @msg3 = Message.create(:parent_id => @msg2.id) # using the object.id
      end
      context "object creation" do
        it "handles basic manipulation" do
          @msg1.should respond_to :parent
          @msg2.should respond_to :children
          @msg1.children.first.should == @msg2
          @msg2.parent.should == @msg1
          @msg3.parent.should == @msg2
          @msg1.parent.should be_nil
          @msg3.children.should == []
        end
      end
      context "object deletion" do
        it "handles deleting a parent", slow: true do
          @msg1.should_not be_nil
          @msg2.parent.should == @msg1
          @msg3.root.should == @msg1
          @msg1.destroy
          @msg2.reload; @msg3.reload
          @msg2.should_not be_nil
          @msg2.should respond_to :parent
          @msg2.parent.should be_nil
          @msg3.parent.should == @msg2
          @msg2.root.should == @msg2
          @msg3.root.should == @msg2
        end
      end
    end

    context "rsvps and valid states" do
      #it "can't have a linked RSVP without a parent"
      #it "can't have a linked RSVP if the parent has no RSVP"
    end

    context "using linked RSVPs", slow: true do
      before(:each) do
        @mem1 = FactoryGirl.create(:member_with_phone_and_email)
        @mem2 = FactoryGirl.create(:member_with_phone_and_email)
        @mesg = {"author_id" => "#{@mem1.id}", "ip_address" => "4.4.4.4", "text" => "zomg"}
        @dist = {"#{@mem1.id}_email" => "on", "#{@mem1.id}_phone" => "on", "#{@mem2.id}_phone" => "on"}
        @rsvp = '{"prompt":"HI", "yes_prompt":"yes", "no_prompt":"NO"}'
        @msg1 = Message.generate(@mesg, @dist, @rsvp)
        new_params = {:parent => @msg1, :linked_rsvp_id => @msg1.id}
        @msg2 = Message.generate(@mesg.merge(new_params), @dist, {})
      end
      it "has the same RSVP prompt" do
        @msg1.rsvp.prompt.should == @msg2.rsvp.prompt
      end
      it "assigns the same linked_rsvp_id to parent and child" do
        @msg1.reload; @msg2.reload
        @msg1.linked_rsvp_id.should == @msg2.linked_rsvp_id
      end
    end

  end
end


# == Schema Information
#
# Table name: messages
#
#  id             :integer         not null, primary key
#  author_id      :integer
#  ip_address     :string(255)
#  text           :text
#  created_at     :datetime
#  updated_at     :datetime
#  format         :string(255)
#  linked_rsvp_id :integer
#  ancestry       :string(255)
#

