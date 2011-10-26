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
    puts "      Members: #{Member.count}"
    puts "    Addresses: #{Address.count}"
    puts "       Emails: #{Email.count}"
    puts "       Phones: #{Phone.count}"
    puts "     Contacts: #{EmergencyContact.count}"
    puts "  Other Infos: #{OtherInfo.count}"
    puts "       Photos: #{Photo.count}"
    puts "        Certs: #{Cert.count}"
    puts "         Docs: #{DataFile.count}"
    puts "     AvailOps: #{AvailOp.count}"
    puts "     AvailDos: #{AvailDo.count}"
    puts "DoAssignments: #{DoAssignment.count}"
  end

  def prompt_array
    [
            {
                    :name       => "Available?",
                    :prompt     => "Are you available?",
                    :yes_prompt => "I am available",
                    :no_prompt  => "I am not available"
            },
            {
                    :name       => "Heads Up",
                    :prompt     => "Would you be available?",
                    :yes_prompt => "I would be available",
                    :no_prompt  => "I would not be available"
            },
            {
                    :name       => "At Home?",
                    :prompt     => "Are you home yet?",
                    :yes_prompt => "I have returned home",
                    :no_prompt  => "I am not home yet"
            },
            {
                    :name       => "Test",
                    :prompt     => "Does this page look ok?",
                    :yes_prompt => "Everything looks good",
                    :no_prompt  => "It has problems"
            }
    ]
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
    prompt_array.each {|x| RsvpTemplate.create(x) }
  end

  def reset_database
    system "rake db:drop"
    system "rake db:drop RAILS_ENV=test"
    system "rm -rf public/system"
    system "rake db:migrate"
    system "rake db:migrate RAILS_ENV=test"
  end

  desc "Restore JSON data"
  task :restore => :data_environment do
    system "xterm_title 'DATA RESTORE'"
    reset_database
    load_data(RosterLoad.parse_from_url)
    Rake::Task['data:count'].invoke
  end

  desc "Import JSON data"
  task :import => :data_environment do
    system "xterm_title 'DATA IMPORT'"
    reset_database
    load_data(RosterLoad.parse_from_url)
    Member.create(:user_name => "system_user")
    Member.create(:user_name => "public_user")
    x = Member.create!(:user_name => "mark_lowpensky", :typ => "A")
    (x.admin = true; x.save) unless x.nil?
    Org.create(:name => "BAMRU")
    Rake::Task['data:photo_load'].invoke
    Rake::Task['data:cert_load'].invoke
    Rake::Task['data:file_load'].invoke
    Phone.where(:position => nil).all.each {|x| x.destroy}
    Email.where(:position => nil).all.each {|x| x.destroy}
    Rake::Task['data:count'].invoke
  end

  desc "Reload Photos"
  task :photo_load => :data_environment do
    puts "Reloading Photos (this might take awhile...)"
    Photo.destroy_all
    Dir.glob('./db/seed/photos/*jpg').sort.each do |i|
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
    doc_dir  = base_dir + '/../../db/seed/certs'
    puts "Downloading all Cert files"
    Dir.chdir(doc_dir)
    system "rm -f *jpg *pdf"
    Cert.with_docs.each do |c|
      system "wget #{c.cert_url}"
    end
  end

  desc "Convert PDF Certs to JPG"
  task :cert_convert => :data_environment do
    base_dir = File.dirname(File.expand_path(__FILE__))
    doc_dir  = base_dir + '/../../db/seed/certs'
    puts "Converting PDF Cert files to JPG"
    Cert.with_pdfs.each do |c|
      puts "> Converting #{c.cert_path}"
      # system "convert -density 300 #{c.doc_path} #{c.final_doc_path}"
    end
  end

  desc "Load Cert Images"
  task :cert_load => :data_environment do
    puts "Loading CERT Images"
    Cert.with_docs.each do |c|
      puts "Updating #{c.cert_path}"
      c.update_attributes(:cert => File.open(c.cert_path))
    end
  end

  desc "Load Files"
  task :file_load => :data_environment do
    puts "Reloading Seed Files (this might take awhile...)"
    DataFile.destroy_all
    Dir.glob('./db/seed/data_files/*').sort.each do |i|
      username = 'andy_leak'
      member = Member.where(:user_name => username).first
      if member
        puts "loading file #{DataFile.count} - #{i.split('/').last} "
        member.data_files.create(:data => File.open(i))
        member.save
      end
    end

  end

end
