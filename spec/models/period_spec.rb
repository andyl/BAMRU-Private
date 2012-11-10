require 'spec_helper'

describe Period do

  def valid_params
    {}
  end

  describe "Object Attributes" do
    before(:each) { @obj = Period.new }
    specify { @obj.should respond_to(:title)            }
  end

  describe "Associations" do
    before(:each) { @obj = Period.new(valid_params)  }
    specify { @obj.should respond_to(:event)        }
    specify { @obj.should respond_to(:participants) }
  end

  describe "Instance Methods" do
    #before(:each) { @obj = Period.new }
    #specify { @obj.should respond_to(:non_standard_typ?) }
  end

  describe "Validations" do

  end

end


# == Schema Information
#
# Table name: periods
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  position   :integer
#  start      :datetime
#  finish     :datetime
#  rsvp_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

