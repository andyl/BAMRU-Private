require 'spec_helper'

describe "members/show.html.erb" do
  before(:each) do
    @member = assign(:member, stub_model(Member))
  end

  it "renders attributes in <p>" do
    render
  end
end
