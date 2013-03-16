require 'spec_helper'

describe EventFileSvc do

  TESTFILE = "/tmp/testfile.txt"

  before(:all) do
    File.open(TESTFILE, 'w') {|f| f.puts "HI"}
  end

  before(:each) do
    @member = Member.create(full_name: "xxx zzz")
    @event  = Event.create(typ: 'meeting', title: "hi", start: Time.now)
  end

  describe "object creation" do

    it "works" do
      params = {}
      params["member_id"] = @member.id
      params["event_id"]  = @event.id
      params["filepath"]  = TESTFILE
      params["caption"]   = "hello world"
      EventFile.count.should == 0
      DataFile.count.should  == 0
      EventFileSvc.new(params)
      EventFile.count.should == 1
      DataFile.count.should  == 1
    end

  end

end