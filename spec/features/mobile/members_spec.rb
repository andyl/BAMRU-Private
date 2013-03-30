require 'spec_helper'

describe "Members", :js => true, :capybara => true do
  describe "GET /mobile1" do
#    #it "works!" do
#    #  get mobile1_path
#    #  response.status.should be(302)
#    #end
    it "logs the user in", slow: true do
      user_name = "asdf_zxcv"
      Member.create!(:user_name => user_name)
      Member.count.should == 1
      visit mobile_path
      Member.count.should == 1
      #current_path.should == mobile_login_path
      current_path.should == '/mobile/login'
      fill_in "user_name", :with => user_name
      fill_in "password",  :with => 'welcome'
      click_button 'Log in'
      #current_path.should == mobile_path
      current_path.should == '/mobile/sessions'
      #current_path.should == "/mobile4"
    end
  end
end
