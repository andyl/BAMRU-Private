require 'spec_helper'

describe "members/forgot.html.erb" do
  before(:each) do
    @member = stub_model(Member)
    @member.stub(:short_name) { 'joe' }
    @message = stub_model(Message)
    assign(:members, [
      stub_model(Member),
      stub_model(Member)
    ])
    view.stub!(:current_member).and_return(@member)
    view.stub!(:current_user).and_return(@member)
    controller.stub!(:current_member).and_return(@member)
    controller.stub!(:current_user).and_return(@member)
    @member.stub(:prev_member).and_return("")
    @member.stub(:prev_member_id).and_return("")
    @member.stub(:next_member).and_return("")
    @member.stub(:next_member_id).and_return("")
  end

  it "renders a list of members" do
#    render
  end
end
