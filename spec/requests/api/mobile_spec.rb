require 'spec_helper'

describe "Mobile API", :capybara => true do
  it "GETs /api/mobile.json" do
    cred = basic_auth("test_one")
    get '/api/mobile.json', nil, {'HTTP_AUTHORIZATION' => cred}
    response.status.should be(200)
  end
end
