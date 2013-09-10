FactoryGirl.define do
  factory :user do
    name "John Doe"
    phone "+420 777 444 999"
    role 0
    sequence(:email) { |n| "user#{n}@example.com" }
    password "12345678"
    password_confirmation { password }
  end
end
