require 'spec_helper'

describe MessageDecorator do

  def valid_atts
    {
      :text      => "Hi",
      :author_id =>  1
    }
  end

  def create_valid_messages(count = 2)
    (1..count).each do |m|
      atts = valid_atts
      atts[:text] = "Helloooooooooooooooo"[0..-m]
      Message.create!(atts)
    end
  end

  before(:each) { @obj = MessageDecorator.new(Message.new(valid_atts)) }
  
  describe "Object Attributes" do
    specify { @obj.should respond_to(:text)         }
    specify { @obj.should respond_to(:author_id)    }
    specify { @obj.should respond_to(:mobile_json)  }
  end

  describe "#mobile_json" do
    before(:each) { @obj = MessageDecorator.new(Message.new(valid_atts)) }
    specify { @obj.mobile_json.should_not be_nil }
    specify { @obj.mobile_json.should be_a(String) }
  end
  
  describe "self.mobile_json" do
    before(:each) do
      create_valid_messages(3)
      @col = MessageDecorator.mobile_json
    end
    specify { @col.should be_a String }
    specify { JSON.parse(@col).should_not be_nil  }
    specify { JSON.parse(@col).should be_an Array }
    specify { JSON.parse(@col).first.should be_a Hash }
  end

end

