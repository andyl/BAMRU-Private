require 'spec_helper'

SAMPLE_HASH = {"22_email" => "on",
               "22_phone" => "on",
               "19_phone" => "on",
               "12_email" => "on"}


describe Message do

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

