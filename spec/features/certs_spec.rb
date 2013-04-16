require 'spec_helper'

describe "Certs", :capybara => true do
  before(:each) do
    login("asdf_qwer")
  end

  describe "GET /unit_certs" do
    it "renders the page", slow: true do
      visit unit_certs_path
      current_path.should == unit_certs_path
      page.should have_content('welcome Asdf')
    end
  end

end
