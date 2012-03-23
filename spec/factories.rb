FactoryGirl.define do

  factory :member do
    first_name "John"
    sequence :last_name  do |n| "Do#{'e' * n}" end
    
    ignore do add_count 3 end
    
    trait :with_phone do
      after_create do |member, evaluator|
        FactoryGirl.create_list(:phone, evaluator.add_count, :member => member)
      end
    end
    
    trait :with_email do
      after_create do |member, evaluator|
        FactoryGirl.create_list(:email, evaluator.add_count, :member => member)
      end
    end

    factory :member_with_phone, :traits => [:with_phone]
    factory :member_with_email, :traits => [:with_email]
    factory :member_with_phone_and_email, :traits => [:with_email, :with_phone]
    factory :member_with_email_and_phone, :traits => [:with_email, :with_phone]

  end

  factory :email do
    pagable  "1"
    sequence :address do |n| "member#{n}@email.com" end
  end

  factory :phone do
    pagable  "1"
    sequence :sms_email do |n| "sms#{n}@sms_mail.com" end
    sequence :number    do |n|
      num = n.to_s
      idx = num.length * -1 - 1
      base = "650-432-0000"
      base[0..idx] + num
    end
  end

  factory :message do
  end

  factory :distribution do
    association :message
  end

end