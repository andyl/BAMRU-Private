require 'spec_helper'

describe "Mobile Members", :capybara => true do
  describe "GET /api/mobile/members.json" do
    it "works!" do
      cred = basic_auth("test_one")
      get '/api/mobile/members.json', nil, {'HTTP_AUTHORIZATION' => cred}
      response.status.should be(200)
    end
  end
end