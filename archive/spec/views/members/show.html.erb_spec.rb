require 'spec_helper'

describe "members/show.html.erb" do
  before(:each) do
    @member = assign(:user, stub_model(User))
  end

  it "renders attributes in <p>" do
    render
  end
end
