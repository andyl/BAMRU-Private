require 'spec_helper'

describe "Members" do
  describe "GET /members" do
    it "works!" do
      get members_path
      response.status.should be(302)
    end
    it "logs the user in" do
      Member.destroy_all
      user_name = "asdf_zxcv"
      Member.create!(:user_name => user_name)
      Member.count.should == 1
      visit '/'
      Member.count.should == 1
      Member.find_by_user_name(user_name).user_name.should == user_name
      current_path.should == login_path
      fill_in "user_name", :with => user_name
      fill_in "password",  :with => 'welcome'
      click_button 'Log in'
      current_path.should == root_path
    end
  end
end
