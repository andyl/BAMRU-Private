require 'spec_helper'

describe EventLinkSvc do

  describe "basic object creation" do

    def fast_params
      {
        "member_id" => 1,
        "event_id"  => 1,
        "site_url"  => "http://news.ycombinator.com",
        "caption"   => "fast params",
      }
    end

    before(:each) { @obj = EventLinkSvc.new(fast_params) }

    specify { @obj.should be_valid            }
    specify { @obj.should_not be_nil          }

  end

  describe "object generation", :slow => true do

    def valid_params
      {
        "member_id" => @member.id,
        "event_id"  => @event.id,
        "site_url"  => "http://news.ycombinator.com",
        "caption"   => "valid params",
      }
    end

    before(:each) do
      @member = Member.create(full_name: "xxx zzz")
      @event  = Event.create(location: "NYC", typ: 'meeting', title: "hi", start: Time.now)
    end

    describe "instance methods" do

      before(:each) { @obj = EventLinkSvc.new(valid_params) }

      describe "#save" do

        it "generates data records" do
          EventLink.count.should == 0
          DataLink.count.should  == 0
          @obj.should be_valid
          @obj.save
          EventLink.count.should == 1
          DataLink.count.should  == 1
        end

        it "has valid associations" do
          @obj.save
          @obj.event.should be_an Event
          @obj.event_links.count.should == 1
          @obj.event_links.first.should be_an EventLink
          @obj.event_link.should be_an EventLink
          @obj.data_links.count.should  == 1
          @obj.data_links.first.should be_a DataLink
          @obj.data_link.should be_a DataLink
        end

        it "returns the correct filename data" do
          @obj.save
          @obj.site_url.should == valid_params["site_url"]
          @obj.updated_at.should_not be_nil
        end

      end

      describe "#update_attributes" do

        it "updates records..." do
          newcap = "HELLO THERE"
          @obj.update_attributes({'caption' => newcap})
          @obj.caption.should == newcap
          @obj.data_link.caption.should == newcap
        end

      end

      describe "#destroy" do

        context "with one EventLink" do
          it "destroys the DataLink and EventLink" do
            EventLink.count.should == 0
            @obj.save
            EventLink.count.should == 1
            DataLink.count.should  == 1
            @obj.destroy
            EventLink.count.should == 0
            DataLink.count.should  == 0
          end
        end

        context "with multiple EventLinks" do
          it "destroys just the EventLink" do
            EventLink.count.should == 0
            @obj.save
            EventLink.create(data_link_id: @obj.data_link.id)
            EventLink.count.should == 2
            DataLink.count.should  == 1
            @obj.destroy
            EventLink.count.should == 1
            DataLink.count.should  == 1
          end
        end

      end

      describe "#to_json" do

      end

    end

    describe ""

    describe "class methods" do

      describe ".create" do

        it "generates data records" do
          EventLink.count.should == 0
          DataLink.count.should  == 0
          obj = EventLinkSvc.create(valid_params)
          obj.should be_valid
          EventLink.count.should == 1
          DataLink.count.should  == 1
        end

      end

      describe ".find" do

        before(:each) { @obj = EventLinkSvc.new(valid_params) }

        it "returns one record" do
          @obj.save
          @obj.id.should be_an Integer
          tst_obj = EventLinkSvc.find(@obj.id)
          tst_obj.caption.should == @obj.caption
          tst_obj.id.should      == @obj.id
          tst_obj.should be_an EventLinkSvc
        end

        it "returns the correct filename data" do
          @obj.save
          tst_obj = EventLinkSvc.find(@obj.id)
          tst_obj.site_url.should == valid_params["site_url"]
          tst_obj.updated_at.should_not be_nil
        end

      end

      describe ".find_by_event" do

        before(:each) { @obj = EventLinkSvc.new(valid_params) }

        it "returns empty array when no records" do
          res = EventLinkSvc.find_by_event(@event.id)
          res.should be_an Array
          res.length.should == 0
        end

        it "returns one record when there is a record" do
          @obj.save
          res = EventLinkSvc.find_by_event(@event.id)
          res.length.should == 1
          res.first.should be_an EventLinkSvc
        end

        it "returns valid attributes" do
          @obj.save
          res = EventLinkSvc.find_by_event(@event.id).first
          res.site_url.should == valid_params["site_url"]
          res.updated_at.should_not be_nil
        end

      end

    end

  end

end