require 'spec_helper'

describe "Api/Rake/Messages", :capybara => true do
  describe "GET /api/rake/messages.json" do
    it "works!" do
      cred = basic_auth("test_one")
      get '/api/rake/messages.json', nil, {'HTTP_AUTHORIZATION' => cred}
      response.status.should be(200)
    end
  end
end