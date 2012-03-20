require 'spec_helper'

describe "Home", :capybara => true do
  before(:each) do
    user_name = "asdf_zxcv"
    member = Member.create!(:user_name => user_name)
    login(member)
  end

  describe "GET /" do
    #it "renders the page" do
    #  visit '/'
    #  current_path.should == '/'
    #  page.should have_content('welcome Asdf')
    #end
  end

end
