# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :settings, :class => 'Settings' do
    token_expiration_period 1
  end
end
