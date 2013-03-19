require 'spec_helper'

describe EventPhotoSvc do

  IMGFILE = Rails.root.to_s + "/public/axe.gif"

  describe "basic object creation" do

    def fast_params
      {
        "member_id" => 1,
        "event_id"  => 1,
        "filepath"  => IMGFILE,
        "caption"   => "fast params"
      }
    end

    before(:each) { @obj = EventPhotoSvc.new(fast_params) }

    specify { @obj.should be_valid            }
    specify { @obj.should_not be_nil          }
    specify { @obj.new_record?.should be_true }

  end

  describe "object generation", :slow => true do

    def valid_params
      {
        "member_id" => @member.id,
        "event_id"  => @event.id,
        "filepath"  => IMGFILE,
        "caption"   => "valid params"
      }
    end

    before(:each) do
      @member = Member.create(full_name: "xxx zzz")
      @event  = Event.create(location: "NYC", typ: 'meeting', title: "hi", start: Time.now)
    end

    describe "instance methods" do

      before(:each) { @obj = EventPhotoSvc.new(valid_params) }

      describe "#save" do

        it "generates data records" do
          EventPhoto.count.should == 0
          DataPhoto.count.should  == 0
          @obj.should be_valid
          @obj.new_record?.should be_true
          @obj.save
          @obj.new_record?.should_not be_true
          EventPhoto.count.should == 1
          DataPhoto.count.should  == 1
        end

        it "has valid associations" do
          @obj.save
          @obj.event.should be_an Event
          @obj.event_photos.count.should == 1
          @obj.event_photos.first.should be_an EventPhoto
          @obj.event_photo.should be_an EventPhoto
          @obj.data_photos.count.should  == 1
          @obj.data_photos.first.should be_a DataPhoto
          @obj.data_photo.should be_a DataPhoto
        end

        it "returns the correct filename data" do
          @obj.save
          @obj.image_file_name.should == IMGFILE.split('/').last
          @obj.image_url.should include IMGFILE.split('/').last
          @obj.updated_at.should_not be_nil
        end

      end

      describe "#update_attributes" do

        it "updates records..." do
          newcap = "HELLO THERE"
          @obj.update_attributes({'caption' => newcap})
          @obj.new_record?.should_not be_true
          @obj.caption.should == newcap
          @obj.data_photo.caption.should == newcap
        end

      end

      describe "#destroy" do

        context "with one EventPhoto" do
          it "destroys the DataPhoto and EventPhoto" do
            EventPhoto.count.should == 0
            @obj.save
            EventPhoto.count.should == 1
            DataPhoto.count.should  == 1
            @obj.destroy
            EventPhoto.count.should == 0
            DataPhoto.count.should  == 0
          end
        end

        context "with multiple EventPhotos" do
          it "destroys just the EventPhoto" do
            EventPhoto.count.should == 0
            @obj.save
            EventPhoto.create(data_photo_id: @obj.data_photo.id)
            EventPhoto.count.should == 2
            DataPhoto.count.should  == 1
            @obj.destroy
            EventPhoto.count.should == 1
            DataPhoto.count.should  == 1
          end
        end

      end

    end

    describe "class methods" do

      describe ".create" do

        it "generates data records" do
          EventPhoto.count.should == 0
          DataPhoto.count.should  == 0
          obj = EventPhotoSvc.create(valid_params)
          obj.should be_valid
          EventPhoto.count.should == 1
          DataPhoto.count.should  == 1
        end

      end

      describe ".find" do

        before(:each) { @obj = EventPhotoSvc.new(valid_params) }

        it "returns one record" do
          @obj.save
          tst_obj = EventPhotoSvc.find(@obj.id)
          tst_obj.caption.should == @obj.caption
          tst_obj.id.should      == @obj.id
          tst_obj.should be_an EventPhotoSvc
        end

        it "returns the correct filename data" do
          @obj.save
          tst_obj = EventPhotoSvc.find(@obj.id)
          tst_obj.image_file_name.should == IMGFILE.split('/').last
          tst_obj.image_url.should include IMGFILE.split('/').last
          tst_obj.updated_at.should_not be_nil
        end

      end

      describe ".find_by_event" do

        before(:each) { @obj = EventPhotoSvc.new(valid_params) }

        it "returns empty array when no records" do
          res = EventPhotoSvc.find_by_event(@event.id)
          res.should be_an Array
          res.length.should == 0
        end

        it "returns one record when there is a record" do
          @obj.save
          res = EventPhotoSvc.find_by_event(@event.id)
          res.length.should == 1
          res.first.should be_an EventPhotoSvc
        end

        it "returns valid attributes" do
          @obj.save
          res = EventPhotoSvc.find_by_event(@event.id).first
          res.image_file_name.should == IMGFILE.split('/').last
          res.image_url.should include IMGFILE.split('/').last
          res.updated_at.should_not be_nil
        end

      end

    end

  end

end