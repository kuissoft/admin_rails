# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	phone "+420123456789"
    email "pavel@remoteassistant.me"
    password "admin"
  end
end
