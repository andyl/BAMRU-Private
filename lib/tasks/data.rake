namespace :data do

  task :data_environment => :environment do
    require 'lib/roster_load'
  end

  desc "Delete all data"
  task :reset => :data_environment do
    Member.destroy_all
  end

  desc "Count Database Objects"
  task :count => :data_environment do
    puts "    Members: #{Member.count}"
    puts "  Addresses: #{Address.count}"
    puts "     Emails: #{Email.count}"
    puts "     Phones: #{Phone.count}"
    puts "   Contacts: #{EmergencyContact.count}"
    puts "Other Infos: #{OtherInfo.count}"
    puts "     Photos: #{Photo.count}"
    puts "      Certs: #{Cert.count}"
  end

  def load_data(json)
    RosterLoad.import(json)
    x = Member.where(:user_name => "andy_leak").first
    (x.admin = true; x.save) unless x.nil?
    (x.developer = true; x.save) unless x.nil?
    x = Member.where(:user_name => "cal_hoagland").first
    (x.admin = true; x.save) unless x.nil?
    x = Member.where(:user_name => "victor_tubbesing").first
    (x.admin = true; x.save) unless x.nil?
    x = Member.where(:user_name => "dan_herman").first
    (x.admin = true; x.save) unless x.nil?
    x = Member.where(:user_name => "will_gilmore").first
    (x.admin = true; x.save) unless x.nil?
    x = Member.where(:user_name => "shane_iseminger").first
    (x.admin = true; x.save) unless x.nil?
  end

  def reset_database
    system "rm db/*sqlite3"
    system "rm -rf public/system"
    system "rake db:migrate"
    system "rake db:migrate RAILS_ENV=test"
  end

  desc "Restore JSON data"
  task :restore => :data_environment do
    system "xterm_title 'DATA RESTORE'"
    reset_database
    load_data(RosterLoad.parse_from_file)
    Rake::Task['data:count'].invoke
  end

  desc "Restore JSON data with Photos and Certs"
  task :full_restore => :data_environment do
    system "xterm_title 'DATA FULL RESTORE'"
    reset_database
    load_data(RosterLoad.load_from_zip)
    Cert.all.each do |cert|
      zip_dir = RosterLoad.zip_dir
      unless cert.document_file_name.nil?
        cert_file = zip_dir + "/certs/" + cert.document_file_name
        puts "Processing #{cert_file}"
        cert.update_attributes(:document => File.open(cert_file))
      end
    end
    Photo.all.each do |photo|
      zip_dir = RosterLoad.zip_dir
      unless photo.image_file_name.nil?
        photo_file = zip_dir + "/photos/" + photo.image_file_name
        photo.update_attributes(:image => File.open(photo_file))
      end
    end
    Rake::Task['data:count'].invoke
  end

  desc "Import JSON data"
  task :import => :data_environment do
    system "xterm_title 'DATA IMPORT'"
    reset_database
    load_data(RosterLoad.parse_from_url)
    x = Member.create!(:user_name => "mark_lowpensky", :typ => "A")
    (x.admin = true; x.save) unless x.nil?
    Org.create(:name => "BAMRU")
    Rake::Task['data:photos'].invoke
    Rake::Task['data:cert_image_load'].invoke
    Phone.where(:position => nil).all.each {|x| x.destroy}
    Email.where(:position => nil).all.each {|x| x.destroy}
    Rake::Task['data:count'].invoke
  end

  desc "Reload Photos"
  task :photos => :data_environment do
    puts "Reloading Photos (this might take awhile...)"
    Photo.destroy_all
    Dir.glob('./db/jpg/*jpg').sort.each do |i|
      username = File.basename(i)[0..-7] #.gsub('_','_')
      member = Member.where(:user_name => username).first
      if member
        puts "loading photo for #{username} (#{Photo.count})"
        member.photos.create(:image => File.open(i))
        member.save
      end
    end
  end

  desc "Download Certs"
  task :cert_download => :data_environment do
    base_dir = File.dirname(File.expand_path(__FILE__))
    doc_dir  = base_dir + '/../../db/docs'
    puts "Downloading all Cert files"
    Dir.chdir(doc_dir)
    system "rm -f *jpg *pdf"
    Cert.with_docs.each do |c|
      system "wget #{c.doc_url}"
    end
  end

  desc "Convert PDF Certs to JPG"
  task :cert_convert => :data_environment do
    base_dir = File.dirname(File.expand_path(__FILE__))
    doc_dir  = base_dir + '/../..db/docs'
    puts "Converting PDF Cert files to JPG"
    Cert.with_pdfs.each do |c|
      puts "> Converting #{c.doc_path}"
      # system "convert -density 300 #{c.doc_path} #{c.final_doc_path}"
    end
  end

  desc "Load Cert Images"
  task :cert_image_load => :data_environment do
    puts "Loading CERT Images"
    Cert.with_docs.each do |c|
      puts "Updating #{c.doc_path}"
      c.update_attributes(:document => File.open(c.doc_path))
    end
  end

end
