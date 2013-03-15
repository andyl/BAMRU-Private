require 'spec_helper'

describe EventLink do

  def valid_params
    {}
  end

  describe "Object Attributes" do
    before(:each) { @obj = EventLink.new }
    specify { @obj.should respond_to(:member_id)             }
    specify { @obj.should respond_to(:event_id)              }
    specify { @obj.should respond_to(:caption)               }
    specify { @obj.should respond_to(:site_url)              }
    specify { @obj.should respond_to(:link_backup)           }
    specify { @obj.should respond_to(:link_backup_file_name) }
  end

  describe "Associations" do
    before(:each) { @obj = EventLink.new               }
    specify { @obj.should respond_to(:event)           }
  end

  #describe "Validations" do
  #end

  describe "Basic Object Creation" do
    before(:each) { @obj = EventLink.create }
    specify { @obj.should be_valid }
    specify { EventLink.count.should == 1 }
  end

  def tgt_dom(url) ; EventLink.new(site_url: url).site_domain end

  describe "#site_domain" do
    specify { tgt_dom("http://google.com").should       == "google.com" }
    specify { tgt_dom("http://news.google.com").should  == "news.google.com" }
    specify { tgt_dom("http://news.google.com/").should == "news.google.com" }
    specify { tgt_dom("http://google.com/news").should  == "google.com" }
  end

  describe "#generate_backup" do
    before(:each) { @obj = EventLink.new(site_url: "http://news.ycombinator.com")}
    it "generates a valid PDF", slow: true do
      @obj.generate_backup
      @obj.link_backup_content_type.should == "application/pdf"
      @obj.link_backup_file_name.should_not be_nil
      @obj.backup_url.should_not be_nil
    end
  end

end

