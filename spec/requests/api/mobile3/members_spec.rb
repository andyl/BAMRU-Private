require 'spec_helper'

describe "Mobile3 Members", :capybara => true do
  describe "GET /api/mobile3/members.json" do
    it "works!" do
      cred = basic_auth("test_one")
      get '/api/mobile3/members.json', nil, {'HTTP_AUTHORIZATION' => cred}
      response.status.should be(200)
    end
  end
end