require 'spec_helper'

describe "home/index.html.erb" do #, :type => :acceptance do

  include Devise::TestHelpers

  before(:each) do
    @user = User.create!(:login => "x.y", :password => "qwerasdf")
    sign_in @user
  end

  it "does basic rendering" do
    render
    rendered.should_not be_nil
  end
  it "shows a header logo" do
    render
    rendered.should include("Pagers and Roster")
  end
end
