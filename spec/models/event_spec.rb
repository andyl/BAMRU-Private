require 'spec_helper'

describe Event do

  def valid_params
    {typ: "operation", location: "maui", title: "HI", start: Time.now}
  end

  describe "Object Attributes" do
    before(:each) { @obj = Event.new }
    specify { @obj.should respond_to(:typ)            }
    specify { @obj.should respond_to(:title)          }
    specify { @obj.should respond_to(:description)    }
    specify { @obj.should respond_to(:lat)            }
    specify { @obj.should respond_to(:lon)            }
    specify { @obj.should respond_to(:start)          }
    specify { @obj.should respond_to(:finish)         }
    specify { @obj.should respond_to(:public)         }
  end

  describe "Associations" do
    before(:each) { @obj = Event.new(valid_params)  }
    specify { @obj.should respond_to(:leaders)      }
    specify { @obj.should respond_to(:periods)      }
  end

  describe "Instance Methods" do
    #before(:each) { @obj = Event.new }
    #specify { @obj.should respond_to(:non_standard_typ?) }
  end

  describe "Validations" do
    context "basic" do
      it { should validate_presence_of(:typ)     }
      it { should validate_presence_of(:title)   }
      it { should validate_presence_of(:start)   }
    end
    it "handles valid event types" do
      %w(meeting training operation special).each do |typ|
        @obj = Event.new(valid_params.merge({typ: typ}))
        @obj.should be_valid
      end
    end
    it "handles invalid event types" do
      @obj = Event.new(:typ => "unknown")
      @obj.should_not be_valid
    end
    context "lat/lon" do
      it "is valid with both lat/lon filled" do
        @obj = Event.new(valid_params.merge({lat: 31.22, lon: -120.33}))
        @obj.should be_valid
      end
      it "is not valid with just lat filled" do
        @obj = Event.new(valid_params.merge({lat: 31.22}))
        @obj.should_not be_valid
      end
      it "is not valid with just lon filled" do
        @obj = Event.new(valid_params.merge({lon: 31.22}))
        @obj.should_not be_valid
      end
    end
  end

end


# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  typ         :string(255)
#  title       :string(255)
#  description :text
#  location    :string(255)
#  lat         :decimal(10, 6)
#  lon         :decimal(10, 6)
#  start       :datetime
#  finish      :datetime
#  public      :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

