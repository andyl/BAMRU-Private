require_relative "../../../app/extensions/message_extension/klass"

class TestKlass
  extend MessageExtension::Klass
end

SAMPLE_HASH = {"22_email" => "on",
               "22_phone" => "on",
               "19_phone" => "on",
               "12_email" => "on"}

describe MessageExtension::Klass do

  describe "class methods" do
    specify { TestKlass.should respond_to :distributions_params        }
    specify { TestKlass.should respond_to :mobile_distributions_params }
  end

  describe "#devices" do
    before(:all) { @array = %w(one two three) }
    specify { TestKlass.send(:devices, @array).should be_a Hash }
  end

  describe "#distributions_params" do
    before(:each) do
      @res = TestKlass.distributions_params(SAMPLE_HASH)
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