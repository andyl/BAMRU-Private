require 'spec_helper'

describe "Members" do
  it "can't access a page if not logged in'" do
    get "/members"
    response.status.should be(302)
  end
end