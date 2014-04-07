# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	phone "+420123456789"
    email "test@remoteassistant.me"
    password "test123"
    role "user"
  end
end
