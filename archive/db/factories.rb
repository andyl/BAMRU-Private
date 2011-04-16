def rand3() ("100".."999").to_a.sample; end
def rand4() ("1000".."9999").to_a.sample; end

require 'faker'

Factory.define :user do |u|
  u.first_name  { Faker::Name.first_name }
  u.last_name   { Faker::Name.last_name  }
end

Factory.define :address do |a|
  a.association :user
  a.addr1 { Faker::Address.street_address    }
  a.addr2 { Faker::Address.secondary_address if (1..3).to_a.sample == 1 }
  a.city  { Faker::Address.city              }
  a.state { Faker::Address.state_abbr        }
  a.zip   { Faker::Address.zip               }
end

Factory.define :phone do |a|
  a.association :user
  a.number { "#{rand3}-#{rand3}-#{rand4}" }
end

Factory.define :email do |a|
  a.association :user
  a.address { Faker::Internet.email }
end

