require 'spec_helper'

describe Distribution do

  describe "associations" do
    before(:all) { @obj = FactoryGirl.create(:distribution) }
    specify { @obj.should respond_to :member           }
    specify { @obj.should respond_to :message          }
    specify { @obj.should respond_to :outbound_mails   }
    specify { @obj.should respond_to :journals         }
  end

  describe "#mark_as_read" do
    before(:each) do
      @obj = FactoryGirl.create(:distribution)
      @mem = FactoryGirl.create(:member)
    end
    it "has valid parameters after creation" do
       @obj.should be_valid
       @obj.should_not be_read
       @obj.read_at.should be_nil
       @obj.response_seconds.should be_nil
    end
    it "updates the read-at date" do
      @obj.mark_as_read(@mem, @mem)
      @obj.read.should be_true
      @obj.read_at.should_not be_nil
      @obj.response_seconds.should_not be_nil
    end
  end

  context "when there are linked RSVPs" do
    before(:each) do
      @mem1 = FactoryGirl.create(:member_with_phone_and_email)
      @mem2 = FactoryGirl.create(:member_with_phone_and_email)
      @mesg = {"author_id" => "#{@mem1.id}", "ip_address" => "4.4.4.4", "text" => "zomg"}
      @dist = {"#{@mem1.id}_email" => "on", "#{@mem1.id}_phone" => "on", "#{@mem2.id}_phone" => "on"}
      @rsvp = '{"prompt":"HI", "yes_prompt":"yes", "no_prompt":"NO"}'
      @msg1 = Message.generate(@mesg, @dist, @rsvp)
      new_params = {parent:@msg1, linked_rsvp_id:@msg1.id}
      @msg2 = Message.generate(@mesg.merge(new_params), @dist, {})
    end
    context "when considering the read status" do
      it "updates the child when the parent is updated" do
        dist1 = Distribution.where(member_id: @mem1.id, message_id: @msg1.id).first
        dist2 = Distribution.where(member_id: @mem1.id, message_id: @msg2.id).first
        dist2.mark_as_read(@mem1, @mem1)
        dist1.reload; dist2.reload
        dist1.should be_read
        dist2.should be_read
      end
      it "updates the parent when the child is updated" do
        dist1 = Distribution.where(member_id: @mem1.id, message_id: @msg1.id).first
        dist2 = Distribution.where(member_id: @mem1.id, message_id: @msg2.id).first
        dist1.mark_as_read(@mem1, @mem1)
        dist1.reload; dist2.reload
        dist1.should be_read
        dist2.should be_read
      end
    end
  end

end

# == Schema Information
#
# Table name: distributions
#
#  id                     :integer         not null, primary key
#  message_id             :integer
#  member_id              :integer
#  email                  :boolean         default(FALSE)
#  phone                  :boolean         default(FALSE)
#  read                   :boolean         default(FALSE)
#  bounced                :boolean         default(FALSE)
#  read_at                :datetime
#  response_seconds       :integer
#  rsvp                   :boolean         default(FALSE)
#  rsvp_answer            :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  unauth_rsvp_token      :string(255)
#  unauth_rsvp_expires_at :datetime
#

