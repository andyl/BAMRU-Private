require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    before(:each) do
      @request.env["devise.mappings"] = Devise.mappings[:user]
      @user = Member.create(:user_name => "Joe.Smith", :password => "asdfasdf")
      sign_in @user
    end
    
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end
