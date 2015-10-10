namespace :data do

  task :environment do
    require File.expand_path('../../../config/environment', __FILE__)
  end

  desc "Count Database Objects"
  task :count => :environment do
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

end
