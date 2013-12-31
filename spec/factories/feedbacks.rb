# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    message "MyText"
    feedback_type "MyString"
    email "MyString"
    user_id 1
  end
end
