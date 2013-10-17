require "spec_helper"

describe Authentication do
  describe ".validate_token" do
    it "returns :invalid if the token doesn't exist" do
      user = create(:user)
      Authentication.validate_token(user, "foo-bar").should == :invalid
    end

    it "returns :expired if the token is expired" do
      user = create(:user)
      user.update_attribute(:token_updated_at, 1.week.ago)
      Authentication.validate_token(user, user.authentication_token).should == :expired
    end

    it "returns :valid if the token is valid and belongs to the user" do
      user = create(:user)
      Authentication.validate_token(user, user.authentication_token).should == :valid
    end
  end
end
