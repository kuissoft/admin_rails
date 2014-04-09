# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:phone) { |n| "+42012345678#{n}" }
    sequence(:email) { |n| "test#{n}@remoteassistant.me" }
    password "test123"
    role "admin"
  end
end
