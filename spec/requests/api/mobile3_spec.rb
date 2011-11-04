require 'spec_helper'

describe "/api/mobile3", :capybara => true do
  describe "GET /api/mobile3.json" do
    it "works!" do
      cred = basic_auth("test_one")
      get '/api/mobile3.json', nil, {'HTTP_AUTHORIZATION' => cred}
      response.status.should be(200)
    end
  end
end
