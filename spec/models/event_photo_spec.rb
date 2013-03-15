require 'spec_helper'

describe EventPhoto do

  def valid_params
    {}
  end

  def test_image
    Rails.root.to_s + "/public/smso_badge.png"
  end

  def new_test_image
    EventPhoto.create(image: File.new(test_image))
  end

  describe "Object Attributes" do
    before(:each) { @obj = EventPhoto.new }
    specify { @obj.should respond_to(:member_id)             }
    specify { @obj.should respond_to(:event_id)              }
    specify { @obj.should respond_to(:caption)               }
    specify { @obj.should respond_to(:image)                 }
  end

  describe "Associations" do
    before(:each) { @obj = EventPhoto.new               }
    specify { @obj.should respond_to(:event)            }
  end

  describe "Basic Object Creation" do
    it "should create an EventPhoto object in the database", slow: true do
      new_test_image.should be_valid
      EventPhoto.count.should == 1
    end
  end

  describe "image generation", slow: true do
    before(:each) { @obj = new_test_image }
    it "generates valid image" do
      @obj.image_content_type.should == "image/png"
      @obj.image_file_name.should == "smso_badge.png"
    end
  end

end

