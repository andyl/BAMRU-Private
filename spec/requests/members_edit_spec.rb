require File.expand_path('../../spec_helper', __FILE__)

describe "Members/Edit", :capybara => true do

  describe "GET /members/edit" do

    before(:each) do
      user_name = "asdf_zxcv"
      @member = Member.create!(:user_name => user_name)
      login(@member)
      visit edit_member_path(@member)
    end

    it "renders the edit page" do
      current_path.should == edit_member_path(@member)
    end

    #it "adds items", :js => true do
    #  click_link('add_phone')
    #  page.should_not be_nil
    #  click_link('add_email')
    #  page.should_not be_nil
    #  click_link('add_phone')
    #  page.should_not be_nil
    #  click_link('add_emergency_contact')
    #  page.should_not be_nil
    #  click_link('add_other_info')
    #  page.should_not be_nil
    #end

  end
end
