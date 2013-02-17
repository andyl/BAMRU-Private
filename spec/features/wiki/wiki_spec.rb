require 'spec_helper'

describe "Wiki @ http://wiki.bamru.net", :capybara => true do
  describe "login" do
    describe "Login" do
      it "works!" do
        visit "http://wiki.bamru.net"
        page.should_not be_nil
      end
      #it "redirects to bamru.net if not logged in" do
      #  visit "http://wiki.bamru.net"
      #  %w(http://bamru.net/login http://bamru.net/home/wiki).should include(current_url)
      #end
      it "does not give an error if logged in" do
        visit "http://wiki.bamru.net/?username=Andy.Leak"
        page.should have_no_content("LOGIN ERROR")
      end
      #it "have_no_content re-login" do
      #  visit "http://wiki.bamru.net/?username=Andy.Leak"
      #  page.should have_content("Andy.Leak")
      #  visit "http://wiki.bamru.net/?username=Test.User"
      #  page.should have_content("Test.User")
      #end
    end
    describe "Session" do
      #it "maintains session after changing the page" do
      #  visit "http://wiki.bamru.net/?username=Andy.Leak"
      #  click_link "Unit Roster"
      #  page.should have_no_content("LOGIN ERROR")
      #end
    end

  end
end
