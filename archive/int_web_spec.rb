require 'integration_helper'

describe "Web Pages" do

  include Capybara

  before(:each) do
    Capybara.app = BamruApp
  end

  context "public pages" do
    it "redirects the home page" do
      visit '/'
      page.status_code.should == 404
    end
    it "renders /calendar.test" do
      visit '/calendar.test'
      page.status_code.should == 200
    end
    it "renders /bamruinfo.test" do
      visit '/bamruinfo.test'
      page.status_code.should == 200
    end
    it "renders /join.test" do
      visit '/join.test'
      page.status_code.should == 200
    end
    it "renders /meetings_locations.test" do
      visit '/meeting_locations.test'
      page.status_code.should == 200
    end
    it "renders /sgallery.test" do
      visit '/sgallery.test'
      page.status_code.should == 200
    end
    it "renders /sarlinks.test" do
      visit '/sarlinks.test'
      page.status_code.should == 200
    end
    it "renders /donate.test" do
      visit '/donate.test'
      page.status_code.should == 200
    end
    it "renders /contact.test" do
      visit '/contact.test'
      page.status_code.should == 200
    end
    it "renders '/calendar.csv" do
      visit '/calendar.csv'
      page.status_code.should == 200
    end
    it "renders '/calendar.ical" do
      visit '/calendar.ical'
      page.status_code.should == 200
    end
  end

  context "admin pages" do
    it "renders /admin" do
      visit '/admin'
      page.status_code.should == 200
    end
    it "renders /admin_show" do
      visit '/admin_show'
      page.status_code.should == 200
    end
    it "renders /admin_load_csv" do
      visit '/admin_load_csv'
      page.status_code.should == 200
    end
  end

end
