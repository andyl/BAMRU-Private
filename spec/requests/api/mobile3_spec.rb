require 'spec_helper'

describe "Mobile3 API", :capybara => true do
  it "GETs /api/mobile3.json" do
    cred = basic_auth("test_one")
    get '/api/mobile3.json', nil, {'HTTP_AUTHORIZATION' => cred}
    response.status.should be(200)
  end
end
