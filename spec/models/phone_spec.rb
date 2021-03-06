require 'spec_helper'

describe Phone do

 describe "Object Attributes" do
   before(:each) { @obj = Phone.new }
   specify { @obj.should respond_to(:id)         }
   specify { @obj.should respond_to(:member_id)  }
   specify { @obj.should respond_to(:typ)        }
   specify { @obj.should respond_to(:number)     }
   specify { @obj.should respond_to(:pagable)    }
   specify { @obj.should respond_to(:sms_email)  }
   specify { @obj.should respond_to(:position)   }
 end

 describe "Associations" do
   before(:each) { @obj = Phone.new }
   specify { @obj.should respond_to(:member)          }
   specify { @obj.should respond_to(:outbound_mails)  }
 end

 describe "Validations" do
   before(:each) { @obj = Phone.new }
   specify { @obj.should validate_format_of(:number).with("123-123-1234") }
 end

 describe "Object Creation" do
   it "works with a number attribute" do
     @obj = Phone.new(:number => "123-123-1234")
     @obj.should be_valid
   end
 end

end

# == Schema Information
#
# Table name: phones
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  typ        :string(255)
#  number     :string(255)
#  pagable    :string(255)
#  sms_email  :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

