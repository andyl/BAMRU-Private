require 'spec_helper'
require 'mail'

describe InboundMail do

  describe "Object Attributes" do
    before(:each) { @obj = InboundMail.new }
    specify { @obj.should respond_to(:outbound_mail_id) }
    specify { @obj.should respond_to(:from)  }
    specify { @obj.should respond_to(:to)  }
  end

  describe "Associations" do
    before(:each) { @obj = InboundMail.new }
    specify { @obj.should respond_to(:outbound_mail)     }
  end

  def gen_mail(arg = {})
    standard_args = {
            :to      => 'reciever@gmail.com',
            :from    => 'sender@gmail.com',
            :subject => 'test subject',
            :body    => 'sample body'
    }
    tgt_args = if arg.class == String
      standard_args.merge({:body => arg})
    else
      standard_args.merge(arg)
    end
    InboundMail.create_from_mail(Mail.new(tgt_args))
  end

  describe "#gen_mail" do
    specify { gen_mail.should_not be_nil              }
    specify { gen_mail.class.should == InboundMail    }
    it "handles attribute over-ride" do
      btxt = "Hello World"
      @obj = gen_mail({:body => btxt})
      @obj.body.should == btxt
    end
  end

  describe ".create_from_mail" do
    specify { gen_mail("yes this is great").rsvp_answer.should   == "Yes"}
    specify { gen_mail("y this is great").rsvp_answer.should     == "Yes"}
    specify { gen_mail("this yes is great").rsvp_answer.should   == "Yes"}
    specify { gen_mail("this yea is great").rsvp_answer.should   == "Yes"}
    specify { gen_mail("this y is great").rsvp_answer.should     == "Yes"}
    specify { gen_mail("this n is great").rsvp_answer.should     == "No" }
    specify { gen_mail("this nO is great").rsvp_answer.should    == "No" }
    specify { gen_mail("this is great").rsvp_answer.should       == nil  }
    specify { gen_mail("this is great").rsvp_answer.should       == nil  }
  end

end


# == Schema Information
#
# Table name: inbound_mails
#
#  id               :integer         not null, primary key
#  outbound_mail_id :integer
#  from             :string(255)
#  to               :string(255)
#  uid              :string(255)
#  subject          :string(255)
#  label            :string(255)
#  body             :string(255)
#  rsvp_answer      :string(255)
#  send_time        :datetime
#  bounced          :boolean         default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#  ignore_bounce    :boolean         default(FALSE)
#

