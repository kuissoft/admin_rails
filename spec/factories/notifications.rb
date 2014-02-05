# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    notification_type "MyString"
    user_id 1
    user_name "MyString"
  end
end
