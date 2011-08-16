require 'spec_helper'
require 'request_helper'

describe "Docs" do
  before(:each) do
    user_name = "asdf_zxcv"
    member = Member.create!(:user_name => user_name)
    login(member)
  end

  describe "docs/new" do
    it "renders the page" do
      visit new_doc_path
      current_path.should == new_doc_path
      page.should have_content('Upload Doc')
    end
    it "loads a doc" do
      filename = "/tmp/asdf.txt"
      system "date > #{filename}"
      visit new_doc_path
      attach_file("Doc", filename)
      click_button("Create Doc")
      Doc.count.should == 1
      page.should have_content("BAMRU Docs")
      page.should have_content("asdf.txt")
    end
  end

  describe "docs" do
    before(:each) do
      filename = "/tmp/asdf.txt"
      system "date > #{filename}"
      visit new_doc_path
      attach_file("Doc", filename)
      click_button("Create Doc")
      visit (docs_path)
    end

    it "shows the uploaded file" do
      page.should have_content("asdf.txt")
      page.should have_content("TXT")
    end
  end

end
