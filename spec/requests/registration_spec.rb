require "spec_helper"

describe "Registration" do
  it "returns 201 status and an auth token for successful registration" do
    attributes = FactoryGirl.attributes_for(:user)
    post "/api/users", user: attributes
    response.status.should == 201
    JSON.parse(response.body).fetch("user").fetch("auth_token").should be_present
  end
end
