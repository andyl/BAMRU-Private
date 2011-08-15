require 'spec_helper'
require 'request_helper'

describe "Home" do
  before(:each) do
    user_name = "asdf_zxcv"
    member = Member.create!(:user_name => user_name)
    login(member)
  end

  describe "GET /" do
    it "renders the page", :js => true do
      visit '/'
      current_path.should == '/'
      page.should have_content('welcome Asdf')
    end
  end

  describe "more" do
    it "renders the page more", :js => true do
      visit '/'
      click_link("js test")
      page.should have_content('js worked')
      sleep 20
    end
  end

end
