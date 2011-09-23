require 'spec_helper'
require 'request_helper'

describe "Certs", :capybara => true do
  before(:each) do
    user_name = "asdf_zxcv"
    member = Member.create!(:user_name => user_name)
    login(member)
  end

  describe "GET /unit_certs" do
    it "renders the page" do
      visit unit_certs_path
      current_path.should == unit_certs_path
      page.should have_content('welcome Asdf')
    end
  end

end
