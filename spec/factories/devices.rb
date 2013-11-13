# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    udid "MyString"
    user_id 1
  end
end
