require 'spec_helper'

describe DataFile do

  def valid_params
    {typ: "operation", location: "maui", title: "HI", start: Time.now}
  end

  def new_test_file(filepath = "/tmp/test.txt")
    File.open(filepath, "w") {|f| f.puts "HI"}
    [filepath, DataFile.create(data: File.new(filepath))]
  end

  describe "Object Attributes" do
    before(:each) { @obj = DataFile.new                 }
    specify { @obj.should respond_to(:member_id)        }
    specify { @obj.should respond_to(:download_count)   }
    specify { @obj.should respond_to(:position)         }
    specify { @obj.should respond_to(:published)        }
  end

  describe "Basic Object Creation" do
    it "should create a DataFile object in the database" do
      new_test_file[1].should be_valid
    end
  end

  describe "Scopes" do
    before(:each) do
      @file_path = "/tmp/test2.txt"
      new_test_file(@file_path)
    end
    describe "self#with_filename" do
      it "returns no results when the filename is unmatched" do
        DataFile.with_filename("unknown_file.txt").count.should == 0
      end
      it "retrieves the right file count with one file in the DB" do
        DataFile.with_filename(@file_path).count.should == 1
      end
      it "retrieves the right file count with two files in the DB" do
        new_test_file(path = "/tmp/test3.txt")
        DataFile.count.should == 2
        DataFile.with_filename(path).count.should == 1
      end
    end
    describe "self#with_filename_like" do
      it "returns zero records for unmatched file" do
        DataFile.with_filename_like("unknown_file.txt").count.should == 0
      end
      it "returns no records for an exact match" do
        DataFile.with_filename_like(@file_path).count.should == 0
      end
      it "returns one record for the right pattern" do
        new_test_file("/tmp/test2_1.txt")
        DataFile.count.should == 2
        DataFile.with_filename_like(@file_path).count.should == 1
      end
      it "returns two record for the right pattern" do
        new_test_file("/tmp/test2_1.txt")
        new_test_file("/tmp/test2_2.txt")
        DataFile.count.should == 3
        DataFile.with_filename_like(@file_path).count.should == 2
      end
    end
    describe "self#filenames" do
      it "returns an array" do
        DataFile.filenames.should be_an(Array)
      end
      it "returns a single record for the test database" do
        DataFile.filenames.length.should == 1
      end
      it "returns the correct filename" do
        DataFile.filenames[0].should == File.basename(@file_path)
      end
      context "with other predicates" do
        before(:each) do
          new_test_file(@tmp_path = "/tmp/test2_1.txt")
        end
        it "returns the right number of names" do
          DataFile.with_filename_like(@file_path).filenames.length.should == 1
        end
        it "returns the right record" do
          name = DataFile.with_filename_like(@file_path).filenames[0]
          name.should == File.basename(@tmp_path)
        end
      end
    end
  end

  describe "#duplicate_filename?" do
    it "returns true with duplicates" do
      path, _ = new_test_file
      new_obj = DataFile.new(data: File.new(path))
      new_obj.duplicate_filename?.should be_true
    end
    it "returns false without duplicates" do
      path1, _ = new_test_file
      path2 = "/tmp/asdf.txt"
      File.open(path2, 'w') {|f| f.puts "HI"}
      new_obj = DataFile.new(data: File.new(path2))
      new_obj.duplicate_filename?.should_not be_true
    end
  end

  describe "Incrementing Filenames" do
    it "increments duplicate filenames" do
      new_test_file[1].data_file_name.should == "test.txt"
      new_test_file[1].data_file_name.should == "test_1.txt"
      new_test_file[1].data_file_name.should == "test_2.txt"
    end
  end

  #describe "Associations" do
  #  before(:each) { @obj = Event.new(valid_params)  }
  #  specify { @obj.should respond_to(:leaders)      }
  #  specify { @obj.should respond_to(:periods)      }
  #end

  #describe "Instance Methods" do
  #  #before(:each) { @obj = Event.new }
  #  #specify { @obj.should respond_to(:non_standard_typ?) }
  #end

  #describe "Validations" do
  #  context "basic" do
  #    it { should validate_presence_of(:typ)     }
  #    it { should validate_presence_of(:title)   }
  #    it { should validate_presence_of(:start)   }
  #  end
  #  it "handles valid event types" do
  #    %w(meeting training operation community).each do |typ|
  #      @obj = Event.new(valid_params.merge({typ: typ}))
  #      @obj.should be_valid
  #    end
  #  end
  #  it "handles invalid event types" do
  #    @obj = Event.new(:typ => "unknown")
  #    @obj.should_not be_valid
  #  end
  #end

end

# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  typ         :string(255)
#  title       :string(255)
#  leaders     :string(255)
#  description :text
#  location    :string(255)
#  lat         :decimal(7, 4)
#  lon         :decimal(7, 4)
#  start       :datetime
#  finish      :datetime
#  all_day     :boolean          default(TRUE)
#  published   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

