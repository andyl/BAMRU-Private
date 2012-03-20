require_relative "../../../app/extensions/member_extension/base"

class TestClass
  include MemberExtension::Base
end

describe MemberExtension::Base do
  before(:all) do
    @obj = TestClass.new
  end

  it "says hi" do
    @obj.should respond_to(:sayhi)
  end

end