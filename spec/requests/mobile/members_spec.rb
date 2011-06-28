require 'spec_helper'

describe "Members" do
  describe "GET /mobile" do
    it "works!" do
      get mobile_path
      response.status.should be(302)
    end
    it "logs the user in" do
      user_name = "asdf_zxcv"
      Member.create!(:user_name => user_name)
      Member.count.should == 1
      visit mobile_path
      Member.count.should == 1
      current_path.should == mobile_login_path
      fill_in "user_name", :with => user_name
      fill_in "password",  :with => 'welcome'
      click_button 'Log in'
      current_path.should == mobile_path
      page.should have_content('BAMRU Mobile')
    end
  end
end
