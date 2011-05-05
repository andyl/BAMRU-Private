require 'spec_helper'

describe "home/index.html.erb" do #, :type => :acceptance do

  it "does basic rendering" do
    render
    rendered.should_not be_nil
  end
  it "shows a header logo" do
    render
    rendered.should include("Pagers and Roster")
  end
end
