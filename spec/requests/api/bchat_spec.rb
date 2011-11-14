require 'spec_helper'

describe "Bchat API", :capybara => true do
  it "GETs /api/bchat.json" do
    cred = basic_auth("test_one")
    get '/api/bchat.json', nil, {'HTTP_AUTHORIZATION' => cred}
    response.status.should be(200)
  end
  it "GETs /api/bchat/chats.json" do
    cred = basic_auth("test_one")
    get '/api/bchat/chats.json', nil, {'HTTP_AUTHORIZATION' => cred}
    response.status.should be(200)
  end
end
