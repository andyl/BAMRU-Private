require 'spec_helper'

describe EventFileSvc do

  TESTFILE = "/tmp/testfile.txt"

  before(:all) do
    File.open(TESTFILE, 'w') {|f| f.puts "HI"}
  end

  describe "basic object creation" do

    def fast_params
      {
        "member_id" => 1,
        "event_id"  => 1,
        "filepath"  => TESTFILE,
        "caption"   => "fast params"
      }
    end

    before(:each) { @obj = EventFileSvc.new(fast_params) }

    specify { @obj.should be_valid            }
    specify { @obj.should_not be_nil          }
    specify { @obj.new_record?.should be_true }

  end

  describe "object generation", :slow => true do

    def valid_params
      {
        "member_id" => @member.id,
        "event_id"  => @event.id,
        "filepath"  => TESTFILE,
        "caption"   => "valid params"
      }
    end

    before(:each) do
      @member = Member.create(full_name: "xxx zzz")
      @event  = Event.create(location: "NYC", typ: 'meeting', title: "hi", start: Time.now)
    end

    describe "instance methods" do

      before(:each) { @obj = EventFileSvc.new(valid_params) }

      describe "#save" do

        it "generates data records" do
          EventFile.count.should == 0
          DataFile.count.should  == 0
          @obj.should be_valid
          @obj.new_record?.should be_true
          @obj.save
          @obj.new_record?.should_not be_true
          EventFile.count.should == 1
          DataFile.count.should  == 1
        end

        it "has valid associations" do
          @obj.save
          @obj.event.should be_an Event
          @obj.event_files.count.should == 1
          @obj.event_files.first.should be_an EventFile
          @obj.event_file.should be_an EventFile
          @obj.data_files.count.should  == 1
          @obj.data_files.first.should be_a DataFile
          @obj.data_file.should be_a DataFile
        end

        it "returns the correct filename data" do
          @obj.save
          @obj.data_file_name.should == TESTFILE.split('/').last
          @obj.data_url.should include TESTFILE.split('/').last
          @obj.updated_at.should_not be_nil
        end

      end

      describe "#update_attributes" do

        it "updates records..." do
          newcap = "HELLO THERE"
          @obj.update_attributes({'caption' => newcap})
          @obj.new_record?.should_not be_true
          @obj.caption.should == newcap
          @obj.data_file.caption.should == newcap
        end

      end

      describe "#destroy" do

        context "with one EventFile" do
          it "destroys the DataFile and EventFile" do
            EventFile.count.should == 0
            @obj.save
            EventFile.count.should == 1
            DataFile.count.should  == 1
            @obj.destroy
            EventFile.count.should == 0
            DataFile.count.should  == 0
          end
        end

        context "with multiple EventFiles" do
          it "destroys just the EventFile" do
            EventFile.count.should == 0
            @obj.save
            EventFile.create(data_file_id: @obj.data_file.id)
            EventFile.count.should == 2
            DataFile.count.should  == 1
            @obj.destroy
            EventFile.count.should == 1
            DataFile.count.should  == 1
          end
        end

      end

    end

    describe "class methods" do

      describe ".create" do

        it "generates data records" do
          EventFile.count.should == 0
          DataFile.count.should  == 0
          obj = EventFileSvc.create(valid_params)
          obj.should be_valid
          EventFile.count.should == 1
          DataFile.count.should  == 1
        end

      end

      describe ".find" do

        before(:each) { @obj = EventFileSvc.new(valid_params) }

        it "returns one record" do
          @obj.save
          tst_obj = EventFileSvc.find(@obj.id)
          tst_obj.caption.should == @obj.caption
          tst_obj.id.should      == @obj.id
          tst_obj.should be_an EventFileSvc
        end

        it "returns the correct filename data" do
          @obj.save
          tst_obj = EventFileSvc.find(@obj.id)
          tst_obj.data_file_name.should == TESTFILE.split('/').last
          tst_obj.data_url.should include TESTFILE.split('/').last
          tst_obj.updated_at.should_not be_nil
        end

      end

      describe ".find_by_event" do

        before(:each) { @obj = EventFileSvc.new(valid_params) }

        it "returns empty array when no records" do
          res = EventFileSvc.find_by_event(@event.id)
          res.should be_an Array
          res.length.should == 0
        end

        it "returns one record when there is a record" do
          @obj.save
          res = EventFileSvc.find_by_event(@event.id)
          res.length.should == 1
          res.first.should be_an EventFileSvc
        end

        it "returns valid attributes" do
          @obj.save
          res = EventFileSvc.find_by_event(@event.id).first
          res.data_file_name.should == TESTFILE.split('/').last
          res.data_url.should include TESTFILE.split('/').last
          res.updated_at.should_not be_nil
        end

      end

    end

  end

end