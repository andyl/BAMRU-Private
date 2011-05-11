require 'spec_helper'

describe "members/edit.html.erb" do
  before(:each) do
    @member = assign(:user, stub_model(User))
  end

  it "renders the edit member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path(@member), :method => "post" do
    end
  end
end
