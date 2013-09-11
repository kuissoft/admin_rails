require "spec_helper"

describe "Authenticaiton" do
  it "returns auth token for valid credentials" do
    user = create(:user, password: "12345678")
    post "/api/authentication", email: user.email, password: "12345678"

    response.status.should == 200
    JSON.parse(response.body).fetch("authentication_token").should be_present
  end

  it "returns 401 and no response for invalid password" do
    user = create(:user, password: "12345678")
    post "/api/authentication", email: user.email, password: "bollocks"

    response.status.should == 401
    response.body.should be_blank
  end

  it "returns 401 for non-existent user (there is no way to tell if a password is wrong or user doesn't exist)" do
    post "/api/authentication", email: "nonexistent@example.com"

    response.status.should == 401
    response.body.should be_blank
  end

end
