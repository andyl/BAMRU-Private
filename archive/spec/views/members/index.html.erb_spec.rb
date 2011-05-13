require 'spec_helper'

describe "members/index.html.erb" do
  before(:each) do
    assign(:members, [
      stub_model(Member),
      stub_model(Member)
    ])
  end

  it "renders a list of members" do
    render
  end
end
