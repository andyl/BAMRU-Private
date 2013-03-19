require 'spec_helper'

describe EventFile do

  #def valid_params
  #  {}
  #end

  describe "Object Attributes" do
    before(:each) { @obj = EventFile.new }
    specify { @obj.should respond_to(:event_id)             }
    specify { @obj.should respond_to(:data_file_id)         }
  end

  describe "Associations" do
    before(:each) { @obj = EventFile.new               }
    specify { @obj.should respond_to(:event)           }
    specify { @obj.should respond_to(:data_file)       }
  end

  #describe "Validations" do
  #end

  #describe "Instance Methods" do
  #end

end

# == Schema Information
#
# Table name: event_files
#
#  id           :integer          not null, primary key
#  event_id     :integer
#  data_file_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

