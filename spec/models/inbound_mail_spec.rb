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

end

# == Schema Information
#
# Table name: inbound_mails
#
#  id               :integer          not null, primary key
#  outbound_mail_id :integer
#  from             :string(255)
#  to               :string(255)
#  uid              :string(255)
#  subject          :string(255)
#  label            :string(255)
#  body             :text
#  rsvp_answer      :string(255)
#  send_time        :datetime
#  bounced          :boolean          default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#  ignore_bounce    :boolean          default(FALSE)
#

