require 'spec_helper'

describe "DataFiles", :capybara => true do
  before(:each) do
    user_name = "asdf_zxcv"
    member = Member.create!(:user_name => user_name)
    login(member)
  end

  describe "files/new" do
    it "renders the page" do
      visit new_file_path
      current_path.should == new_file_path
      #page.should have_content('Upload File')
    end
    #it "loads a file" do
    #  filename = "/tmp/asdf.txt"
    #  system "date > #{filename}"
    #  visit new_file_path
    #  attach_file("File", filename)
    #  click_button("Create Data file")
    #  DataFile.count.should == 1
    #  page.should have_content("BAMRU Files")
    #  page.should have_content("asdf.txt")
    #end
  end

  describe "file" do
    before(:each) do
      filename = "/tmp/asdf.txt"
      system "date > #{filename}"
      visit new_file_path
      attach_file("File", filename)
      click_button("Create Data file")
      visit (files_path)
    end

    #it "shows the uploaded file" do
    #  page.should have_content("asdf.txt")
    #  page.should have_content("TXT")
    #end

    #it "doesn't upload duplicate file names'" do
    #  filename = "/tmp/asdf.txt"
    #  visit new_file_path
    #  attach_file("File", filename)
    #  click_button("Create Data file")
    #  current_path.should == files_path
    #  page.should have_content("Error")
    #end
  end

end
