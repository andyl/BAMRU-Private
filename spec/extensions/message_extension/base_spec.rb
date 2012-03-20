require_relative "../../../app/extensions/message_extension/base"

class TestClass
  include MessageExtension::Base
end

describe MessageExtension::Base do
  before(:all) { @obj = TestClass.new }

  describe "object creation" do

    specify { @obj.should respond_to :breakify }
    specify { @obj.should respond_to :label4c  }

  end

  describe "label4c" do
    specify { @obj.label4c.length.should == 4 }
  end

  describe "breakify" do
    it "handles short strings" do
      string = "asdf"
      @obj.breakify(string).should == string
    end

    it "handles long strings" do
      string = "x" * 75
      @obj.breakify(string).should_not == string
      @obj.breakify(string).length.should == 76
    end
  end

end