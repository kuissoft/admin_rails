require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "new user automatically gets an authentication token" do
    user = FactoryGirl.create(:user)
    assert user.authentication_token.present?
  end

  test "user gets a new authenticaton token if he doesn't get one" do
    user = FactoryGirl.create(:user)
    user.authentication_token = nil
    user.save!

    assert user.authentication_token.present?
  end
end
