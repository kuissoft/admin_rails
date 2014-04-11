# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    sequence(:auth_token) { |n| "123-45#{n}" }
    sequence(:phone) { |n| "+42012345678#{n}" }
    sequence(:uuid) { |n| "3s2d4fd2f4fd#{n}" }
    language "en"
    association :user
  end
end
