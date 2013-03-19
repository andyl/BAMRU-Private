require 'spec_helper'

describe DataPhoto do

  def valid_params
    {}
  end

  def test_image
    Rails.root.to_s + "/public/smso_badge.png"
  end

  def new_test_image
    DataPhoto.create(image: File.new(test_image))
  end

  describe "Object Attributes" do
    before(:each) { @obj = DataPhoto.new }
    specify { @obj.should respond_to(:member_id)             }
    specify { @obj.should respond_to(:caption)               }
    specify { @obj.should respond_to(:image)                 }
  end

  describe "Associations" do
    before(:each) { @obj = DataPhoto.new                 }
    specify { @obj.should respond_to(:events)            }
    specify { @obj.should respond_to(:event_photos)      }
  end

  describe "Basic Object Creation" do
    it "should create an EventPhoto object in the database", slow: true do
      new_test_image.should be_valid
      DataPhoto.count.should == 1
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

# == Schema Information
#
# Table name: data_photos
#
#  id                 :integer          not null, primary key
#  member_id          :integer
#  caption            :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :integer
#  position           :integer
#  published          :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

