require 'spec_helper'

describe DataLink do

  def valid_params
    {member_id: 1, site_url: 'http://bamru.org', event_id: 1}
  end

  describe "Object Attributes" do
    before(:each) { @obj = DataLink.new }
    specify { @obj.should respond_to(:member_id)             }
    specify { @obj.should respond_to(:caption)               }
    specify { @obj.should respond_to(:site_url)              }
    specify { @obj.should respond_to(:link_backup)           }
    specify { @obj.should respond_to(:link_backup_file_name) }
  end

  describe "Associations" do
    before(:each) { @obj = DataLink.new(valid_params)  }
    specify { @obj.should respond_to(:events)          }
    specify { @obj.should respond_to(:event_links)     }
  end

  #describe "Validations" do
  #end

  describe "Basic Object Creation" do
    before(:each) { @obj = DataLink.create }
    specify { @obj.should be_valid }
    specify { DataLink.count.should == 1 }
  end

  def tgt_dom(url) ; DataLink.new(site_url: url).site_domain end

  describe "#site_domain" do
    specify { tgt_dom("http://google.com").should       == "google.com" }
    specify { tgt_dom("http://news.google.com").should  == "news.google.com" }
    specify { tgt_dom("http://news.google.com/").should == "news.google.com" }
    specify { tgt_dom("http://google.com/news").should  == "google.com" }
  end

  describe "#generate_backup" do
    before(:each) { @obj = DataLink.new(site_url: "http://news.ycombinator.com")}
    it "generates a valid PDF", slow: true do
      @obj.generate_backup
      @obj.link_backup_content_type.should == "application/pdf"
      @obj.link_backup_file_name.should_not be_nil
      @obj.backup_url.should_not be_nil
    end
  end

end

# == Schema Information
#
# Table name: data_links
#
#  id                       :integer          not null, primary key
#  member_id                :integer
#  site_url                 :string(255)
#  caption                  :string(255)
#  published                :boolean          default(FALSE)
#  link_backup_file_name    :string(255)
#  link_backup_content_type :string(255)
#  link_backup_file_size    :integer
#  link_backup_updated_at   :integer
#  position                 :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

