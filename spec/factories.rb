FactoryGirl.define do
  factory :user do
    name "John Doe"
    sequence(:phone) { |n| "+420 777 444 99#{n}" }
    role 0
    sequence(:email) { |n| "user#{n}@example.com" }
    password "12345678"
    password_confirmation { password }
  end
end

