require 'spec_helper'

# see https://www.relishapp.com/rspec/rspec-rails/docs/controller-specs

describe "/eapi/events/<event_id>/event_files" do

  TESTFILE = "/tmp/testfile.txt"

  before(:all) do
    File.open(TESTFILE, 'w') {|f| f.puts "HI"}
  end

  def valid_params
    {
        "member_id" => @member.id,
        "event_id"  => @event.id,
        "filepath"  => TESTFILE,
        "caption"   => "valid params"
    }
  end

  def auth_hash
    { 'HTTP_AUTHORIZATION' => basic_auth("xx_yy") }
  end

  before(:each) do
    @member = Member.create(full_name: "xx yy", :password => "welcome")
    @event  = Event.create(location: "NYC", typ: 'meeting', title: "hi", start: Time.now)
    @obj    = EventFileSvc.create(valid_params)
  end

  describe "GET index" do

    it "works", slow: true do
      get "/eapi/events/#{@event.id}/event_files.json", nil, auth_hash
      response.header["Content-Type"].should include "application/json"
      response.status.should == 200
    end

  end

end