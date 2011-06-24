require 'spec_helper'

describe "members/show.html.erb" do
  before(:each) do
    @member = assign(:member, stub_model(Member))
    view.stub!(:current_member).and_return(@member)
    view.stub!(:current_user).and_return(@member)
    controller.stub!(:current_member).and_return(@member)
    controller.stub!(:current_user).and_return(@member)
    @member.stub(:prev_member).and_return(stub_model(Member))
    @member.stub(:prev_member_id).and_return(1)
    @member.stub(:next_member).and_return(stub_model(Member))
    @member.stub(:next_member_id).and_return(2)
  end

  it "renders attributes" do
    render
  end
end
