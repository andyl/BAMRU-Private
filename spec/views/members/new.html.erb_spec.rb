require 'spec_helper'

describe "members/new.html.erb" do
  before(:each) do
    assign(:member, stub_model(Member).as_new_record)
  end

  it "renders new member form" do
#    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
#    assert_select "form", :action => members_path, :method => "post" do
#    end
  end
end
