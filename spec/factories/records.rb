# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :record do
    caller_id 1
    original_caller_id 1
    assistant_id 1
    accepted_at "2015-04-17 17:56:31"
    declined_at "2015-04-17 17:56:31"
    started_at "2015-04-17 17:56:31"
    ended_at "2015-04-17 17:56:31"
    ended_by 1
    error "MyString"
  end
end
