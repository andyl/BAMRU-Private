require 'spec_helper'

describe "Members", :capybara => true do
    it "logs the user in" do
      user_name = "asdf_zxcv"
      Member.create!(:user_name => user_name)
      Member.count.should == 1
      visit root_path
      current_path.should == login_path
      fill_in "user_name", :with => user_name
      fill_in "password",  :with => 'welcome'
      click_button 'Log in'
      current_path.should == root_path
      page.should have_content('welcome Asdf')
    end
    it "works with the login method" do
      user_name = "asdf_zxcv"
      member = login(user_name)
      Member.count.should == 1
      visit root_path
      current_path.should == root_path
      page.should have_content('welcome Asdf')
    end
end
