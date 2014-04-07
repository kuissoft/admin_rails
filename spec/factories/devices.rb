# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    auth_token "123-456"
    phone "+420123456789"
    uuid "3s2d4fd2f4fd2"
    language "en"
    association :user
  end
end
