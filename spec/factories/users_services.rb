# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :users_service do
    user_id 1
    service_id 1
    notify_available false
  end
end
