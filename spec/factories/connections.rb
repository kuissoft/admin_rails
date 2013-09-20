# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :connection do
    user_id 1
    contact_id 1
    is_pending false
  end
end
