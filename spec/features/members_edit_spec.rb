require File.expand_path('../../spec_helper', __FILE__)

describe "Members/Edit", :capybara => true do

  before(:each) do
    @member = login("asdf_zxcv")
    visit edit_member_path(@member)
  end

  context "Basic Testing" do

    it "renders the edit page", slow: true do
      current_path.should == edit_member_path(@member)
    end

  end

  context "JavaScript Testing" do

    # it "updates the name", js: true do
    #   new_name = "New Namez"
    #   fill_in 'member_full_name', with: new_name
    #   click_link "Save"
    #   page.should_not be_nil
    #   page.should have_content(new_name)
    #   current_path.should == member_path(@member)
    # end

    # it "adds items", js: true do
    #   click_link('add_phone')
    #   page.should_not be_nil
    #   click_link('add_email')
    #   page.should_not be_nil
    #   click_link('add_phone')
    #   page.should_not be_nil
    #   click_link('add_emergency_contact')
    #   page.should_not be_nil
    #   click_link('add_other_info')
    #   page.should_not be_nil
    # end
  end
end
