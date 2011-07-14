desc "Import JSON data"
task :import => :environment do
  system "xterm_title 'DATA IMPORT'"
  system "rm db/*sqlite3"
  system "rm -rf public/system"
  system "rake db:migrate"
  system "rake db:migrate RAILS_ENV=test"
  require 'lib/roster_load'
  RosterLoad.import(RosterLoad.parse)
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
  x = Member.create!(:user_name => "mark_lowpensky", :typ => "A")
  (x.admin = true; x.save) unless x.nil?
  Org.create(:name => "BAMRU")
  Rake::Task['photos'].invoke
  Rake::Task['cert_image_load'].invoke
  Phone.where(:position => nil).all.each {|x| x.destroy}
  Email.where(:position => nil).all.each {|x| x.destroy}
end

desc "Reload Photos"
task :photos => :environment do
  puts "Reloading Photos (this might take awhile...)"
  Photo.destroy_all
  Dir.glob('./db/jpg/*jpg').sort.each do |i|
    username = File.basename(i)[0..-7] #.gsub('_','_')
    member = Member.where(:user_name => username).first
    if member
      member.photos.create(:image => File.open(i))
      member.save
    end
  end
end

desc "Download Certs"
task :cert_download => :environment do
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
task :cert_convert => :environment do
  base_dir = File.dirname(File.expand_path(__FILE__))
  doc_dir  = base_dir + '/../..db/docs'
  puts "Converting PDF Cert files to JPG"
  Cert.with_pdfs.each do |c|
    puts "> Converting #{c.doc_path}"
    # system "convert -density 300 #{c.doc_path} #{c.final_doc_path}"
  end
end

desc "Load Cert Images"
task :cert_image_load => :environment do
  puts "Loading CERT Images"
  Cert.with_docs.each do |c|
    puts "Updating #{c.doc_path}"
    c.update_attributes(:document => File.open(c.doc_path))
  end
end
