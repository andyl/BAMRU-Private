namespace :data do

  desc "Count Database Objects"
  task :count do # => :data_environment do
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
