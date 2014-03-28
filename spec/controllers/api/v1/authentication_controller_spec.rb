require "spec_helper"

describe Api::V1::AuthenticationController, type: :controller do
  describe "POST :authenticate" do
    it "Authentication" do
      post :authenticate, user: FactoryGirl.create(:authenticate)
      JSON.parse(response.body).should be_success
    end
  end
end