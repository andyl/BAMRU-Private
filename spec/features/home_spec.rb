require 'spec_helper'

describe "Home", :capybara => true do
  before(:each) do
    login("asdf_zxcv")
  end

  describe "GET /" do
    it "renders the page" do
      visit '/'
      current_path.should == '/'
      page.should have_content('welcome Asdf')
    end
  end

end
