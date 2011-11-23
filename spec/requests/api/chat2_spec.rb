require 'spec_helper'

describe "Chat2 API", :capybara => true do
  it "GETs /api/chat2.json" do
    cred = basic_auth("test_one")
    get '/api/chat2.json', nil, {'HTTP_AUTHORIZATION' => cred}
    response.status.should be(200)
  end
  it "GETs /api/chat2/chats.json" do
    cred = basic_auth("test_one")
    get '/api/chat2/chats.json', nil, {'HTTP_AUTHORIZATION' => cred}
    response.status.should be(200)
  end
end
