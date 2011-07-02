desc "Count Database Objects"
task :count => :environment do
  puts "    Members: #{Member.count}"
  puts "  Addresses: #{Address.count}"
  puts "     Emails: #{Email.count}"
  puts "     Phones: #{Phone.count}"
end