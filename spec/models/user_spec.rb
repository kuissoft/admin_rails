require "spec_helper"

describe User do
  it "new user automatically gets an authentication token" do
    user = FactoryGirl.create(:user)
    user.authentication_token.should be_present
  end

  it "user gets a new authenticaton token if he doesn't get one" do
    user = FactoryGirl.create(:user)
    user.authentication_token = nil
    user.save!

    user.authentication_token.should be_present
  end
end
