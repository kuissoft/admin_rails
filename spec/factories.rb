FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "John Doe #{n}" }
    sequence(:phone) { |n| "+420 777 444 99#{n}" }
    role 0
    sequence(:email) { |n| "user#{n}@example.com" }
    password "12345678"
    password_confirmation { password }
  end
end

